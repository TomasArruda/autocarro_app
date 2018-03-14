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

ActiveRecord::Schema.define(version: 20180314025155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "bus_stops", force: :cascade do |t|
    t.integer "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buses", force: :cascade do |t|
    t.string "registration_number"
    t.integer "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "connections", force: :cascade do |t|
    t.integer "trip_duration"
    t.bigint "start_stop_id"
    t.bigint "end_stop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_stop_id"], name: "index_connections_on_end_stop_id"
    t.index ["start_stop_id"], name: "index_connections_on_start_stop_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "bus_id"
    t.bigint "trip_id"
    t.time "start_time"
    t.time "end_time"
    t.integer "bus_interval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "timetable_from_station", default: {}, null: false
    t.hstore "timetable_to_station", default: {}, null: false
    t.index ["bus_id"], name: "index_schedules_on_bus_id"
    t.index ["trip_id"], name: "index_schedules_on_trip_id"
  end

  create_table "trip_bus_stops", force: :cascade do |t|
    t.bigint "trip_id"
    t.bigint "bus_stop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_stop_id"], name: "index_trip_bus_stops_on_bus_stop_id"
    t.index ["trip_id"], name: "index_trip_bus_stops_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "schedules", "buses"
  add_foreign_key "schedules", "trips"
  add_foreign_key "trip_bus_stops", "bus_stops"
  add_foreign_key "trip_bus_stops", "trips"
end
