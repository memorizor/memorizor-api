# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141214183400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text    "content",     null: false
    t.integer "question_id", null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "catagories", force: :cascade do |t|
    t.string  "name",    null: false
    t.string  "color",   null: false
    t.integer "user_id", null: false
  end

  add_index "catagories", ["user_id"], name: "index_catagories_on_user_id", using: :btree

  create_table "collections", force: :cascade do |t|
    t.integer "catagory_id", null: false
    t.integer "question_id", null: false
  end

  add_index "collections", ["catagory_id"], name: "index_collections_on_catagory_id", using: :btree
  add_index "collections", ["question_id"], name: "index_collections_on_question_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "content",     null: false
    t.datetime "review_at",   null: false
    t.integer  "answer_type", null: false
    t.integer  "user_id",     null: false
  end

  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "name",                            null: false
    t.string  "email",                           null: false
    t.string  "password_digest"
    t.boolean "verified",        default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

end
