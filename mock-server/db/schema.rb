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

ActiveRecord::Schema.define(version: 20170804120735) do

  create_table "mock_responses", force: :cascade do |t|
    t.string "url"
    t.string "parameters"
    t.string "method"
    t.integer "response_status_code"
    t.text "response_body"
    t.integer "test_run_id"
    t.string "response_mime_type"
    t.string "response_encoding"
  end

  create_table "test_runs", force: :cascade do |t|
    t.string "name"
    t.datetime "started"
    t.datetime "ended"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_test_runs_on_name", unique: true
  end

  create_table "tracking_events", force: :cascade do |t|
    t.text "content"
    t.integer "test_run_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
