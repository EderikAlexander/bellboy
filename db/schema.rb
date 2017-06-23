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

ActiveRecord::Schema.define(version: 20170622125407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachinary_files", force: :cascade do |t|
    t.string   "attachinariable_type"
    t.integer  "attachinariable_id"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.integer  "user_id"
    t.integer  "service_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["service_id"], name: "index_bookings_on_service_id", using: :btree
    t.index ["user_id"], name: "index_bookings_on_user_id", using: :btree
  end

  create_table "hotels", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.index ["deleted_at"], name: "index_hotels_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_hotels_on_user_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "category"
    t.integer  "hotel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.float    "latitude"
    t.float    "longitude"
    t.index ["deleted_at"], name: "index_locations_on_deleted_at", using: :btree
    t.index ["hotel_id"], name: "index_locations_on_hotel_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.string   "from"
    t.json     "content"
    t.integer  "stay_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_messages_on_deleted_at", using: :btree
    t.index ["stay_id"], name: "index_messages_on_stay_id", using: :btree
  end

  create_table "rooms", force: :cascade do |t|
    t.integer  "number"
    t.string   "room_type"
    t.integer  "hotel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_rooms_on_deleted_at", using: :btree
    t.index ["hotel_id"], name: "index_rooms_on_hotel_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "price"
    t.integer  "hotel_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_services_on_deleted_at", using: :btree
    t.index ["hotel_id"], name: "index_services_on_hotel_id", using: :btree
  end

  create_table "stays", force: :cascade do |t|
    t.string   "start_booking_date"
    t.string   "end_booking_date"
    t.string   "checked_in"
    t.string   "checked_out"
    t.integer  "user_id"
    t.integer  "hotel_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "deleted_at"
    t.integer  "room_id"
    t.index ["deleted_at"], name: "index_stays_on_deleted_at", using: :btree
    t.index ["hotel_id"], name: "index_stays_on_hotel_id", using: :btree
    t.index ["user_id"], name: "index_stays_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "passport"
    t.datetime "deleted_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_picture_url"
    t.string   "token"
    t.datetime "token_expiry"
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "bookings", "services"
  add_foreign_key "bookings", "users"
  add_foreign_key "hotels", "users"
  add_foreign_key "locations", "hotels"
  add_foreign_key "messages", "stays"
  add_foreign_key "rooms", "hotels"
  add_foreign_key "services", "hotels"
  add_foreign_key "stays", "hotels"
  add_foreign_key "stays", "users"
end
