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

ActiveRecord::Schema.define(version: 20180523172819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "sales"
    t.integer "costs"
    t.integer "gross_profit"
  end

  create_table "admins", force: :cascade do |t|
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
    t.string "user_type"
    t.bigint "member_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["member_id"], name: "index_admins_on_member_id"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "credits", force: :cascade do |t|
    t.string "name"
    t.integer "amount"
    t.string "status"
    t.string "description"
    t.bigint "order_id"
    t.index ["order_id"], name: "index_credits_on_order_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logs", force: :cascade do |t|
    t.integer "orderid"
    t.string "user_name"
    t.datetime "starttime"
    t.datetime "endtime"
    t.string "amount"
    t.string "job_type"
    t.integer "cost"
    t.string "fixed_type"
  end

  create_table "members", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "job_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_rate"
    t.integer "day_rate"
    t.integer "night_rate"
    t.integer "time_cost"
    t.integer "day_cost"
    t.integer "night_cost"
    t.integer "fixed_rate"
    t.integer "fixed_cost"
    t.integer "normal_fixed_cost"
    t.integer "hotel_fixed_cost"
    t.string "password"
  end

  create_table "orders", force: :cascade do |t|
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.datetime "starttime"
    t.datetime "endtime"
    t.integer "amount"
    t.string "status"
    t.bigint "member_id"
    t.string "job_type"
    t.integer "cost"
    t.string "fixed_type"
    t.string "creditor_name"
    t.boolean "time_tracked"
    t.string "to_company"
    t.boolean "add_order"
    t.index ["member_id"], name: "index_orders_on_member_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registration_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "rate_per_hour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "admins", "members"
  add_foreign_key "credits", "orders"
  add_foreign_key "orders", "members"
  add_foreign_key "orders", "users"
end
