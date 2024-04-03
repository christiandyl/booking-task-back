# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_01_060720) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coaches", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reserved_slots", force: :cascade do |t|
    t.bigint "coach_id"
    t.bigint "slot_id"
    t.date "reserved_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id", "slot_id", "reserved_at"], name: "index_reserved_slots_on_coach_id_and_slot_id_and_reserved_at", unique: true
    t.index ["coach_id"], name: "index_reserved_slots_on_coach_id"
    t.index ["slot_id"], name: "index_reserved_slots_on_slot_id"
  end

  create_table "slots", force: :cascade do |t|
    t.bigint "coach_id"
    t.string "timezone", null: false
    t.integer "day_of_week", default: 0
    t.time "available_at", null: false
    t.time "available_until", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id", "day_of_week", "available_at", "available_until"], name: "idx_on_coach_id_day_of_week_available_at_available__4c5904add5", unique: true
    t.index ["coach_id"], name: "index_slots_on_coach_id"
  end

end
