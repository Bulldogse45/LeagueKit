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

ActiveRecord::Schema.define(version: 20151215043400) do

  create_table "games", force: :cascade do |t|
    t.string   "begin_time"
    t.integer  "participant1_id"
    t.integer  "participant2_id"
    t.integer  "location_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "leagues", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "season_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
  end

  create_table "player_participants", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "date_of_birth"
    t.string   "shirt_size"
    t.integer  "jersey_number"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "suffix"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "team_participants", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "location_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.integer  "user_id"
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
  end

end
