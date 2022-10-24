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

ActiveRecord::Schema[7.0].define(version: 2022_10_24_181323) do
  create_table "artists", force: :cascade do |t|
    t.string "login"
    t.string "password"
    t.string "full_name"
    t.string "nickname"
    t.string "login_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "login"
    t.string "password"
    t.string "full_name"
    t.string "login_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "artist_id", null: false
    t.integer "service_id", null: false
    t.string "order_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_orders_on_artist_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["service_id"], name: "index_orders_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "orders", "artists"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "services"
end
