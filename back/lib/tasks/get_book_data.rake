require 'net/http'
namespace :get_book_data do
  desc "ISBNから本データの取得"
  task import_book: :environment do
    puts Book.last
    lines = []
    i = 0
      File.open("app/assets/csv/book.csv", "r") do |f|
        f.each_line do |isbn|
          save_book_data(isbn)
          i += 1
          print "#{i}\n"
        end
      end
  end
  
  desc "本日の本データの取得"
  task today_book: :environment do
    xml = HTTP.get("https://www.hanmoto.com/ci/bd/search/sdate/today/edate/today/hdt/%E6%96%B0%E3%81%97%E3%81%84%E6%9C%AC/order/desc/vw/rss20").to_s
    rss = Feedjira.parse(xml)
    i = 0
    rss.entries.each do |item|
      isbn = item.url.split(File::SEPARATOR).last
      save_book_data(isbn)
      i += 1
      print "#{i}\n"
    end
  end

  desc "翌日の本データの取得"
  task next_day_book: :environment do
    xml = HTTP.get("https://www.hanmoto.com/ci/bd/search/sdate/day/edate/day/hdt/%E6%98%8E%E6%97%A5%E7%99%BA%E5%A3%B2%E3%81%AE%E6%9C%AC/order/desc/vw/rss20").to_s
    rss = Feedjira.parse(xml)
    i = 0
    rss.entries.each do |item|
      isbn = item.url.split(File::SEPARATOR).last
      save_book_data(isbn, NextDayBook)
      i += 1
      print "#{i}\n"
    end
  end

  def save_book_data(isbn, type = Book)
    isbn_10 = isbn_convert(isbn)
    amazon_url = "https://www.amazon.co.jp/dp/#{isbn_10}"
    honto_url = "http://honto.jp/redirect.html?bookno=#{isbn.chop}"
    open_bd_url = "https://api.openbd.jp/v1/get?isbn=#{isbn_10}"

    arr = get_book_info(open_bd_url)
    if arr == nil
      return
    end
    book_content = nil
    c_code = nil
    subject_word = nil

    book_isbn = arr[0]["onix"]["RecordReference"] rescue nil
    book_title = arr[0]["onix"]["DescriptiveDetail"]["TitleDetail"]["TitleElement"]["TitleText"]["content"] rescue nil
    book_subtitle = arr[0]["onix"]["DescriptiveDetail"]["TitleDetail"]["TitleElement"]["Subtitle"]["content"] rescue nil
    book_contributor = arr[0]["onix"]["DescriptiveDetail"]["Contributor"][0]["PersonName"]["content"] rescue nil

    is_present = arr[0]["onix"]["CollateralDetail"]["TextContent"].present? rescue nil
    if is_present
      4.downto(0) do |i|
        is_present = arr[0]["onix"]["CollateralDetail"]["TextContent"][i]["Text"].present? rescue nil
        if is_present
          book_content = arr[0]["onix"]["CollateralDetail"]["TextContent"][i]["Text"] + '<br><br>' rescue nil
          book_content = book_content + arr[0]["onix"]["CollateralDetail"]["TextContent"][i]["Text"] + '<br>' rescue nil
          break
        end
      end
    end

    book_imprint = arr[0]["onix"]["PublishingDetail"]["Imprint"]["ImprintName"] rescue nil
    book_publisher = arr[0]["onix"]["PublishingDetail"]["Publisher"]["PublisherName"] rescue nil
    book_picture = arr[0]["onix"]["CollateralDetail"]["SupportingResource"][0]["ResourceVersion"][0]["ResourceLink"] rescue nil
    book_price = arr[0]["onix"]["ProductSupply"]["SupplyDetail"]["Price"][0]["PriceAmount"] rescue nil
    book_date = arr[0]["onix"]["PublishingDetail"]["PublishingDate"][0]["Date"] rescue nil
    audience_type = arr[0]["onix"]["DescriptiveDetail"]["Audience"][0]["AudienceCodeType"] rescue nil
    audience_code = arr[0]["onix"]["DescriptiveDetail"]["Audience"][0]["AudienceCodeValue"] rescue nil

    is_present = arr[0]["onix"]["DescriptiveDetail"]["Subject"].present? rescue nil
    if is_present                                          
      2.downto(0) do |i|
        is_true = arr[0]["onix"]["DescriptiveDetail"]["Subject"][i]["SubjectSchemeIdentifier"] == 78 rescue nil 
        
        if is_true
          c_code = arr[0]["onix"]["DescriptiveDetail"]["Subject"][i]["SubjectCode"] rescue nil
        end
        arr[0]["onix"]["DescriptiveDetail"]["Subject"][i]["SubjectSchemeIdentifier"] == 20 rescue nil
        if
          subject_word = arr[0]["onix"]["DescriptiveDetail"]["Subject"][i]["SubjectHeadingText"] rescue nil
        end
      end
    end

    if audience_type.blank?
      audience_type = 99  
    end
    if audience_code.blank?
      audience_code=99
    end
    if c_code.blank?
      c_code = 9999
    end
    if book_picture.blank?
      book_picture = "no_image.png"
    else
      book_picture.sub!(/cover.openbd.jp/, "cover.openbd.jp//")
    end

    if book_title.blank?
      book_title = "名無しの本"
    end
  
    type.create(
      isbn: isbn,
      amazon_url: amazon_url,
      honto_url: honto_url,
      isbn_10: isbn_10,
      title: book_title,
      subtitle: book_subtitle,
      contributor: book_contributor,
      content: book_content,
      imprint: book_imprint,
      publisher: book_publisher,
      picture: book_picture,
      audience_type: audience_type,
      audience_code: audience_code,
      c_code: c_code,
      publishing_date: book_date,
      price: book_price,
      subject_text: subject_word
    ) rescue nil
  end

  def isbn_convert(isbn)
    #isbn13→isbn10
    isbn13_array = []
    isbn13_array = isbn.chars.map(&:to_i)
    checkdigit_10 = (10 * isbn13_array[3] + 9 * isbn13_array[4] + 8 * isbn13_array[5] + 7 * isbn13_array[6] + 6 * isbn13_array[7] + 5 * isbn13_array[8] + 4 * isbn13_array[9] + 3 * isbn13_array[10] + 2 * isbn13_array[11]) % 11
    checkdigit_10 = 11 - checkdigit_10
    
    if checkdigit_10==10
      checkdigit_10 = ''
    elsif checkdigit_10 == 11
      checkdigit_10 = '0';
    end
    isbn13_array = isbn13_array.map(&:to_s)
    isbn10_result = []
    isbn13_array.each_with_index{|number, i| isbn10_result << number if (3..11).include?(i)}
    isbn10_result << checkdigit_10
    return isbn10_result.join
  end

  def get_book_info(open_bd_url)
    uri = URI.parse(open_bd_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(req)
    hash = JSON.parse(response.body)
  end
end
