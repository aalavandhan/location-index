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

ActiveRecord::Schema.define(version: 20140405020037) do

  create_table "access_tokens", force: true do |t|
    t.string   "token"
    t.boolean  "expired",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bounds"
  end

  create_table "location_index_restaurants", force: true do |t|
    t.integer  "restaurant_id"
    t.integer  "location_index_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "location_index_restaurants", ["location_index_id"], name: "index_location_index_restaurants_on_location_index_id"
  add_index "location_index_restaurants", ["restaurant_id"], name: "index_location_index_restaurants_on_restaurant_id"

  create_table "location_indices", force: true do |t|
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_count"
    t.float    "latitude_a"
    t.float    "latitude_b"
    t.float    "latitude_c"
    t.float    "latitude_d"
    t.float    "longitude_a"
    t.float    "longitude_b"
    t.float    "longitude_c"
    t.float    "longitude_d"
    t.string   "full_address"
    t.string   "locality"
  end

  create_table "restaurants", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "locality"
    t.float    "rating_editor_overall"
    t.float    "cost_for_two"
    t.boolean  "has_discount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "image"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true

  create_table "tags", force: true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

end
