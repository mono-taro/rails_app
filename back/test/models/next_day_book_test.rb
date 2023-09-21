# == Schema Information
#
# Table name: next_day_books
#
#  id              :bigint           not null, primary key
#  amazon_url      :string(255)      not null
#  audience_code   :integer
#  audience_type   :integer
#  c_code          :integer
#  content         :text(65535)
#  contributor     :string(255)
#  discarded_at    :datetime
#  honto_url       :string(255)      not null
#  imprint         :string(255)
#  isbn            :bigint           not null
#  isbn_10         :bigint           not null
#  picture         :string(255)      not null
#  price           :integer
#  publisher       :string(255)
#  publishing_date :date
#  subject_text    :string(255)
#  subtitle        :string(255)
#  title           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class NextDayBookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end