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

ActiveRecord::Schema[7.0].define(version: 2023_08_06_023426) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "hll"
  enable_extension "plpgsql"

  create_table "daily_rollups", force: :cascade do |t|
    t.datetime "date"
    t.hll "users"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "github_events", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "event_type"
    t.boolean "event_public"
    t.bigint "repo_id"
    t.jsonb "payload"
    t.jsonb "repo"
    t.bigint "user_id"
    t.jsonb "org"
    t.datetime "created_at", precision: nil
    t.index ["event_id"], name: "index_github_events_on_event_id"
  end

end
