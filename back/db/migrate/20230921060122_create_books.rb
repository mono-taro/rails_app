class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.bigint :isbn, null: false,  unique: true
      t.string :title, null: false
      t.string :subtitle
      t.text :content
      t.string :contributor
      t.string :imprint
      t.string :publisher
      t.string :picture, null: false
      t.integer :price
      t.date :publishing_date
      t.integer :audience_type
      t.integer :audience_code
      t.integer :c_code
      t.string :subject_text
      t.bigint :isbn_10, null: false, unique: true
      t.string :amazon_url, null: false, unique: true
      t.string :honto_url, null: false, unique: true
      t.datetime :discarded_at

      t.timestamps
    end
  end
end
