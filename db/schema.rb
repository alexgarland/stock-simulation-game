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

ActiveRecord::Schema.define(version: 20151211071830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "option_assets", force: :cascade do |t|
    t.string   "symbol"
    t.string   "asset_type"
    t.decimal  "number"
    t.decimal  "strike_price"
    t.decimal  "value"
    t.decimal  "duration"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.string   "symbol"
    t.string   "asset_type"
    t.decimal  "number"
    t.decimal  "price"
    t.decimal  "value"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "symbol"
    t.decimal  "cost"
    t.string   "asset_type"
    t.decimal  "shares"
    t.decimal  "price"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.decimal  "cash",            default: 500000.0
    t.decimal  "net_worth"
    t.decimal  "debt"
  end

end
