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

ActiveRecord::Schema.define(version: 20180312200910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_foreign_key "trip_bus_stops", "bus_stops"
  add_foreign_key "trip_bus_stops", "trips"
end
