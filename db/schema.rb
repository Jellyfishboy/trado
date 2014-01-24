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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140124142904) do

  create_table "accessories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "part_number", :limit => 255
  end

  create_table "addresses", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "address"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.string   "country"
    t.integer  "telephone"
    t.boolean  "active",           :default => true
    t.boolean  "default",          :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "addressable_id"
    t.string   "addressable_type"
  end

  create_table "attachments", :force => true do |t|
    t.string   "description"
    t.string   "file"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "attribute_types", :force => true do |t|
    t.string   "name"
    t.string   "measurement"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "cart_items", :force => true do |t|
    t.integer  "cart_id"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "quantity",                                 :default => 1
    t.decimal  "price",      :precision => 8, :scale => 2
    t.integer  "order_id"
    t.integer  "sku_id"
    t.decimal  "weight",     :precision => 8, :scale => 2
  end

  create_table "carts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "visible",     :default => false
    t.string   "slug"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "destinations", :force => true do |t|
    t.integer  "shipping_id"
    t.integer  "country_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "email"
    t.integer  "notifiable_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "sent",            :default => false
    t.datetime "sent_at"
    t.string   "notifiable_type"
  end

  create_table "order_items", :force => true do |t|
    t.decimal  "price",      :precision => 8, :scale => 2
    t.integer  "quantity"
    t.string   "sku_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "order_id"
    t.decimal  "weight",     :precision => 8, :scale => 2
  end

  create_table "orders", :force => true do |t|
    t.string   "email"
    t.integer  "tax_number"
    t.string   "shipping_status",                                    :default => "Pending"
    t.datetime "shipping_date"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.decimal  "actual_shipping_cost", :precision => 8, :scale => 2
    t.string   "status"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.integer  "shipping_id"
    t.string   "ip_address"
    t.integer  "user_id"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "weighting"
    t.integer  "part_number"
    t.string   "sku"
    t.integer  "category_id"
    t.string   "slug"
    t.string   "meta_description"
    t.boolean  "featured"
    t.boolean  "active",           :default => true
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "redactor_assets", :force => true do |t|
    t.integer  "user_id"
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], :name => "idx_redactor_assetable"
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_redactor_assetable_type"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "shippings", :force => true do |t|
    t.string   "name"
    t.decimal  "price",       :precision => 8, :scale => 2
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.text     "description"
    t.boolean  "active",                                    :default => true
  end

  create_table "skus", :force => true do |t|
    t.decimal  "price",               :precision => 8, :scale => 2
    t.decimal  "cost_value",          :precision => 8, :scale => 2
    t.integer  "stock"
    t.integer  "stock_warning_level"
    t.string   "sku"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.integer  "product_id"
    t.decimal  "length",              :precision => 8, :scale => 2
    t.decimal  "weight",              :precision => 8, :scale => 2
    t.decimal  "thickness",           :precision => 8, :scale => 2
    t.string   "attribute_value"
    t.integer  "attribute_type_id"
    t.integer  "accessory_id"
    t.boolean  "active",                                            :default => true
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tiereds", :force => true do |t|
    t.integer  "shipping_id"
    t.integer  "tier_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tiers", :force => true do |t|
    t.decimal  "length_start",    :precision => 8, :scale => 2
    t.decimal  "length_end",      :precision => 8, :scale => 2
    t.decimal  "weight_start",    :precision => 8, :scale => 2
    t.decimal  "weight_end",      :precision => 8, :scale => 2
    t.decimal  "thickness_start", :precision => 8, :scale => 2
    t.decimal  "thickness_end",   :precision => 8, :scale => 2
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "transactions", :force => true do |t|
    t.string   "transaction_id"
    t.string   "transaction_type"
    t.string   "payment_type"
    t.decimal  "fee",              :precision => 8, :scale => 2
    t.string   "payment_status"
    t.integer  "order_id"
    t.decimal  "gross_amount",     :precision => 8, :scale => 2
    t.decimal  "tax_amount",       :precision => 8, :scale => 2
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.decimal  "net_amount",       :precision => 8, :scale => 2
    t.string   "status_reason"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "role",                   :default => "user"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
