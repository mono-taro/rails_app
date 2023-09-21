# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_09_21_122755) do

  create_table "books", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "isbn", null: false
    t.string "title", null: false
    t.string "subtitle"
    t.text "content"
    t.string "contributor"
    t.string "imprint"
    t.string "publisher"
    t.string "picture", null: false
    t.integer "price"
    t.date "publishing_date"
    t.integer "audience_type"
    t.integer "audience_code"
    t.integer "c_code"
    t.string "subject_text"
    t.bigint "isbn_10", null: false
    t.string "amazon_url", null: false
    t.string "honto_url", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "next_day_books", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "isbn", null: false
    t.string "title", null: false
    t.string "subtitle"
    t.text "content"
    t.string "contributor"
    t.string "imprint"
    t.string "publisher"
    t.string "picture", null: false
    t.integer "price"
    t.date "publishing_date"
    t.integer "audience_type"
    t.integer "audience_code"
    t.integer "c_code"
    t.string "subject_text"
    t.bigint "isbn_10", null: false
    t.string "amazon_url", null: false
    t.string "honto_url", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
