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

ActiveRecord::Schema.define(version: 20160104004840) do

  create_table "announcement_vieweds", force: :cascade do |t|
    t.integer  "announce_id"
    t.integer  "user_id"
    t.boolean  "viewed",      default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "announces", force: :cascade do |t|
    t.text     "content"
    t.integer  "announcable_id"
    t.string   "announcable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "announces", ["announcable_id", "announcable_type"], name: "index_announces_on_announcable_id_and_announcable_type"

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows"

  create_table "games", force: :cascade do |t|
    t.datetime "begin_time"
    t.integer  "away_team_id"
    t.integer  "home_team_id"
    t.integer  "location_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "tournament_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "season_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name"
    t.string   "league_logo_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.text     "notes"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "league_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "to_user_id"
    t.integer  "from_user_id"
    t.text     "subject"
    t.text     "content"
    t.integer  "message_status_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "index_message_id"
  end

  create_table "player_participants", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.date     "date_of_birth"
    t.string   "shirt_size"
    t.integer  "jersey_number"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "suffix"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "player_photo_id"
  end

  create_table "referees", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "notes"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "tournament_id"
    t.integer  "original_id"
    t.string   "team_logo_id"
  end

  create_table "to_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "location_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "name"
    t.integer  "user_id"
    t.integer  "league_id"
    t.string   "tournament_logo_id"
    t.integer  "ref_buffer"
    t.integer  "location_buffer"
    t.integer  "team_buffer"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token", null: false
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "phone3"
    t.string   "phone4"
    t.string   "phone5"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "email_optout"
    t.string   "username"
    t.string   "suffix"
  end

end
