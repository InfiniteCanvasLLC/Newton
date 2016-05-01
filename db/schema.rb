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

ActiveRecord::Schema.define(version: 20160501060442) do

  create_table "parties", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parties_users", id: false, force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "party_id", null: false
  end

  add_index "parties_users", ["user_id", "party_id"], name: "by_user_and_party", unique: true

  create_table "questions", force: :cascade do |t|
    t.string   "text"
    t.integer  "question_type"
    t.string   "metadata_one"
    t.string   "metadata_two"
    t.string   "metadata_three"
    t.string   "metadata_four"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "user_actions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "action_type"
    t.integer  "action_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_actions", ["user_id"], name: "index_user_actions_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
