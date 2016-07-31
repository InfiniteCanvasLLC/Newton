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

ActiveRecord::Schema.define(version: 20160731071359) do

  create_table "event_registrations", force: :cascade do |t|
    t.integer  "party_id"
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "commitment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_registrations", ["party_id"], name: "index_event_registrations_on_party_id"

  create_table "events", force: :cascade do |t|
    t.text     "description"
    t.integer  "event_type"
    t.datetime "start"
    t.string   "metadata"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "events_parties", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "party_id", null: false
  end

  create_table "favorite_infos", force: :cascade do |t|
    t.text     "top_artists"
    t.text     "top_songs"
    t.text     "top_genre"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "favorite_infos", ["user_id"], name: "index_favorite_infos_on_user_id"

  create_table "join_party_requests", force: :cascade do |t|
    t.integer  "party_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "link_tos", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.text     "url"
    t.string   "link_text"
    t.string   "icon_style"
    t.string   "panel_style"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "type_id",     default: 0
  end

  create_table "mailkick_opt_outs", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "user_type"
    t.boolean  "active",     default: true, null: false
    t.string   "reason"
    t.string   "list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mailkick_opt_outs", ["email"], name: "index_mailkick_opt_outs_on_email"
  add_index "mailkick_opt_outs", ["user_id", "user_type"], name: "index_mailkick_opt_outs_on_user_id_and_user_type"

  create_table "parties", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "owner_user_id"
    t.text     "description"
  end

  create_table "parties_users", id: false, force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "party_id", null: false
  end

  add_index "parties_users", ["user_id", "party_id"], name: "by_user_and_party", unique: true

  create_table "party_conversations", force: :cascade do |t|
    t.integer  "party_id"
    t.text     "message"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "party_conversations", ["party_id"], name: "index_party_conversations_on_party_id"

  create_table "party_invites", force: :cascade do |t|
    t.integer  "party_id"
    t.integer  "src_user_id"
    t.integer  "dst_user_id"
    t.string   "dst_user_name"
    t.string   "dst_user_email"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "party_metadata", force: :cascade do |t|
    t.integer  "party_id"
    t.integer  "data_type"
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "party_metadata", ["party_id"], name: "index_party_metadata_on_party_id"

  create_table "question_answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.integer  "answer_integer"
    t.text     "answer_text"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "question_answers", ["question_id"], name: "index_question_answers_on_question_id"
  add_index "question_answers", ["user_id"], name: "index_question_answers_on_user_id"

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

  create_table "user_feedbacks", force: :cascade do |t|
    t.integer  "sentiment"
    t.integer  "issue_type"
    t.string   "email"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_metadata", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "data_type"
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_metadata", ["user_id"], name: "index_user_metadata_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "current_party_index"
    t.string   "secondary_email",     default: ""
    t.integer  "gender",              default: 0
    t.date     "birthday",            default: '2016-06-13'
    t.integer  "zip_code",            default: 0
    t.text     "description",         default: ""
    t.datetime "last_seen"
    t.integer  "permissions",         default: 0
  end

end
