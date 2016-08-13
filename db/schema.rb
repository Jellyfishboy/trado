# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160812165314) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "part_number"
    t.decimal  "price",       precision: 8, scale: 2
    t.decimal  "weight",      precision: 8, scale: 2
    t.decimal  "cost_value",  precision: 8, scale: 2
    t.boolean  "active",                              default: true
  end

  create_table "accessorisations", force: :cascade do |t|
    t.integer  "accessory_id"
    t.integer  "product_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "address"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.string   "country"
    t.string   "telephone"
    t.boolean  "active",           default: true
    t.boolean  "default",          default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.integer  "order_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "file"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "default_record",  default: false
  end

  create_table "cart_item_accessories", force: :cascade do |t|
    t.integer  "cart_item_id"
    t.decimal  "price",        precision: 8, scale: 2
    t.integer  "quantity",                             default: 1
    t.integer  "accessory_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer  "cart_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "quantity",                           default: 1
    t.decimal  "price",      precision: 8, scale: 2
    t.integer  "sku_id"
    t.decimal  "weight",     precision: 8, scale: 2
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "delivery_id"
    t.string   "country"
    t.text     "delivery_service_ids"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "active",           default: false
    t.string   "slug"
    t.integer  "sorting",          default: 0
    t.string   "page_title"
    t.string   "meta_description"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "popular",          default: false
    t.string   "alpha_two_code"
    t.string   "alpha_three_code"
    t.string   "currency"
    t.boolean  "transactional",    default: false
  end

  create_table "delivery_service_prices", force: :cascade do |t|
    t.string   "code"
    t.decimal  "price",               precision: 8, scale: 2
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.text     "description"
    t.boolean  "active",                                      default: true
    t.decimal  "min_weight",          precision: 8, scale: 2
    t.decimal  "max_weight",          precision: 8, scale: 2
    t.decimal  "min_length",          precision: 8, scale: 2
    t.decimal  "max_length",          precision: 8, scale: 2
    t.decimal  "min_thickness",       precision: 8, scale: 2
    t.decimal  "max_thickness",       precision: 8, scale: 2
    t.integer  "delivery_service_id"
  end

  create_table "delivery_services", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "courier_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                                      default: true
    t.decimal  "order_price_minimum", precision: 8, scale: 2, default: 0.0
    t.decimal  "order_price_maximum", precision: 8, scale: 2
    t.string   "tracking_url"
  end

  create_table "destinations", force: :cascade do |t|
    t.integer  "delivery_service_id"
    t.integer  "country_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "email"
    t.integer  "notifiable_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "sent",            default: false
    t.datetime "sent_at"
    t.string   "notifiable_type"
  end

  create_table "order_item_accessories", force: :cascade do |t|
    t.integer  "order_item_id"
    t.decimal  "price",         precision: 10
    t.integer  "quantity"
    t.integer  "accessory_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.decimal  "price",      precision: 8, scale: 2
    t.integer  "quantity"
    t.integer  "sku_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "order_id"
    t.decimal  "weight",     precision: 8, scale: 2
  end

  create_table "orders", force: :cascade do |t|
    t.string   "email"
    t.datetime "shipping_date"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.decimal  "actual_shipping_cost",    precision: 8, scale: 2
    t.integer  "delivery_id"
    t.string   "ip_address"
    t.integer  "user_id"
    t.decimal  "net_amount",              precision: 8, scale: 2
    t.decimal  "gross_amount",            precision: 8, scale: 2
    t.decimal  "tax_amount",              precision: 8, scale: 2
    t.boolean  "terms"
    t.integer  "cart_id"
    t.integer  "shipping_status",                                 default: 0
    t.string   "consignment_number"
    t.integer  "payment_type"
    t.string   "browser"
    t.integer  "status",                                          default: 0
    t.string   "paypal_express_token"
    t.string   "paypal_express_payer_id"
    t.string   "stripe_customer_token"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "page_title"
    t.string   "meta_description"
    t.boolean  "active",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "template_type"
    t.string   "menu_title"
    t.integer  "sorting",          default: 0
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "weighting"
    t.integer  "part_number"
    t.string   "sku"
    t.integer  "category_id"
    t.string   "slug"
    t.string   "meta_description"
    t.boolean  "featured"
    t.boolean  "active",                  default: true
    t.text     "short_description"
    t.integer  "status",                  default: 0
    t.integer  "order_count",             default: 0
    t.string   "page_title"
    t.string   "googlemerchant_brand"
    t.string   "googlemerchant_category"
  end

  create_table "redactor_assets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], name: "idx_redactor_assetable", using: :btree
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_redactor_assetable_type", using: :btree

  create_table "related_products", id: false, force: :cascade do |t|
    t.integer "product_id"
    t.integer "related_id"
  end

  add_index "related_products", ["product_id", "related_id"], name: "index_related_products_on_product_id_and_related_id", unique: true, using: :btree
  add_index "related_products", ["related_id", "product_id"], name: "index_related_products_on_related_id_and_product_id", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       default: "user"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "sku_variants", force: :cascade do |t|
    t.integer  "sku_id"
    t.integer  "variant_type_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skus", force: :cascade do |t|
    t.decimal  "price",               precision: 8, scale: 2
    t.decimal  "cost_value",          precision: 8, scale: 2
    t.integer  "stock"
    t.integer  "stock_warning_level"
    t.string   "code"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "product_id"
    t.decimal  "length",              precision: 8, scale: 2
    t.decimal  "weight",              precision: 8, scale: 2
    t.decimal  "thickness",           precision: 8, scale: 2
    t.boolean  "active",                                      default: true
  end

  create_table "stock_adjustments", force: :cascade do |t|
    t.string   "description"
    t.integer  "adjustment",  default: 1
    t.integer  "sku_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "stock_total"
  end

  create_table "store_settings", force: :cascade do |t|
    t.string   "name",                                  default: "Trado"
    t.string   "email",                                 default: "admin@example.com"
    t.string   "currency",                              default: "GBP|£"
    t.string   "tax_name",                              default: "VAT"
    t.integer  "user_id"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.string   "ga_code",                               default: "UA-XXXXX-X"
    t.boolean  "ga_active",                             default: false
    t.decimal  "tax_rate",      precision: 8, scale: 2, default: 20.0
    t.boolean  "tax_breakdown",                         default: false
    t.string   "theme_name",                            default: "redlight"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "transaction_type"
    t.string   "payment_type"
    t.decimal  "fee",              precision: 8, scale: 2
    t.integer  "order_id"
    t.decimal  "gross_amount",     precision: 8, scale: 2
    t.decimal  "tax_amount",       precision: 8, scale: 2
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.decimal  "net_amount",       precision: 8, scale: 2
    t.string   "status_reason"
    t.integer  "payment_status",                           default: 0
    t.integer  "error_code"
    t.string   "paypal_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "first_name",             default: "Joe"
    t.string   "last_name",              default: "Bloggs"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "variant_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
