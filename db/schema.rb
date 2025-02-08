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

ActiveRecord::Schema[8.0].define(version: 2025_02_08_072729) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "building_name"
    t.string "street_address"
    t.string "phone"
    t.bigint "user_id", null: false
    t.string "country_name"
    t.string "state_name"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "product_variant_id", null: false
    t.bigint "cart_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
    t.index ["product_variant_id"], name: "index_cart_items_on_product_variant_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkouts", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "address_id", null: false
    t.bigint "user_id", null: false
    t.string "payment_method"
    t.decimal "total_price"
    t.string "status"
    t.string "payment_status"
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.string "razorpay_signature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.string "coupon_code"
    t.decimal "tax", precision: 10, scale: 2, default: "0.0"
    t.index ["address_id"], name: "index_checkouts_on_address_id"
    t.index ["cart_id"], name: "index_checkouts_on_cart_id"
    t.index ["user_id"], name: "index_checkouts_on_user_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code"
    t.decimal "discount"
    t.text "description"
    t.date "valid_from"
    t.date "valid_until"
    t.integer "max_usage"
    t.boolean "status"
    t.decimal "minimum_purchase_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.bigint "product_variant_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.decimal "total", precision: 10, scale: 2, null: false
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.index ["product_variant_id"], name: "index_order_items_on_product_variant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "total_price", precision: 10, scale: 2
    t.string "payment_method"
    t.string "payment_status"
    t.string "status", default: "processing"
    t.string "transaction_id"
    t.datetime "completed_at"
    t.datetime "delivered_at"
    t.bigint "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["payment_status"], name: "index_orders_on_payment_status"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_variants", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "size_id", null: false
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variants_on_product_id"
    t.index ["size_id"], name: "index_product_variants_on_size_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "base_price"
    t.decimal "discount_percentage"
    t.decimal "total_price"
    t.bigint "category_id", null: false
    t.bigint "subcategory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["subcategory_id"], name: "index_products_on_subcategory_id"
  end

  create_table "return_requests", force: :cascade do |t|
    t.bigint "order_item_id", null: false
    t.bigint "user_id", null: false
    t.string "status", default: "pending", null: false
    t.text "reason"
    t.text "admin_notes"
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_item_id"], name: "index_return_requests_on_order_item_id"
    t.index ["status"], name: "index_return_requests_on_status"
    t.index ["user_id"], name: "index_return_requests_on_user_id"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallet_transactions", force: :cascade do |t|
    t.bigint "wallet_id", null: false
    t.decimal "amount"
    t.string "transaction_type"
    t.text "description"
    t.decimal "balance_after"
    t.string "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "checkout_id"
    t.index ["wallet_id"], name: "index_wallet_transactions_on_wallet_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "balance", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "product_variants"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "checkouts", "addresses"
  add_foreign_key "checkouts", "carts"
  add_foreign_key "checkouts", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "product_variants"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "users"
  add_foreign_key "product_variants", "products"
  add_foreign_key "product_variants", "sizes"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "subcategories"
  add_foreign_key "return_requests", "order_items"
  add_foreign_key "return_requests", "users"
  add_foreign_key "subcategories", "categories"
  add_foreign_key "wallet_transactions", "wallets"
  add_foreign_key "wallets", "users"
end
