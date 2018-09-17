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

ActiveRecord::Schema.define(version: 20180915125442) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ecomm_addresses", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "order_id"
    t.string "first_name"
    t.string "last_name"
    t.string "street_address"
    t.string "city"
    t.string "zip"
    t.string "country"
    t.string "phone"
    t.string "address_type"
    t.index ["customer_id"], name: "index_ecomm_addresses_on_customer_id"
    t.index ["order_id"], name: "index_ecomm_addresses_on_order_id"
  end

  create_table "ecomm_coupons", force: :cascade do |t|
    t.string "code"
    t.datetime "expires"
    t.integer "discount"
  end

  create_table "ecomm_credit_cards", force: :cascade do |t|
    t.bigint "order_id"
    t.string "number"
    t.string "cardholder"
    t.string "month_year"
    t.string "cvv"
    t.index ["order_id"], name: "index_ecomm_credit_cards_on_order_id"
  end

  create_table "ecomm_line_items", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "order_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_ecomm_line_items_on_order_id"
    t.index ["product_id"], name: "index_ecomm_line_items_on_product_id"
  end

  create_table "ecomm_orders", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "shipment_id"
    t.bigint "coupon_id"
    t.string "state"
    t.integer "subtotal_cents", default: 0, null: false
    t.string "subtotal_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_id"], name: "index_ecomm_orders_on_coupon_id"
    t.index ["customer_id"], name: "index_ecomm_orders_on_customer_id"
    t.index ["shipment_id"], name: "index_ecomm_orders_on_shipment_id"
  end

  create_table "ecomm_shipments", force: :cascade do |t|
    t.string "shipping_method"
    t.integer "days_min"
    t.integer "days_max"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
  end

  create_table "members", force: :cascade do |t|
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
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "raw_products", force: :cascade do |t|
    t.json "image"
    t.string "name"
    t.text "desc"
    t.integer "cost_cents", default: 0, null: false
    t.string "cost_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  add_foreign_key "ecomm_addresses", "ecomm_orders", column: "order_id"
  add_foreign_key "ecomm_credit_cards", "ecomm_orders", column: "order_id"
  add_foreign_key "ecomm_line_items", "ecomm_orders", column: "order_id"
  add_foreign_key "ecomm_orders", "ecomm_coupons", column: "coupon_id"
  add_foreign_key "ecomm_orders", "ecomm_shipments", column: "shipment_id"
end
