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

ActiveRecord::Schema.define(:version => 20140316031142) do

  create_table "attachments", :force => true do |t|
    t.string   "source_file_name"
    t.string   "source_content_type"
    t.integer  "source_file_size"
    t.datetime "source_updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "bills", :force => true do |t|
    t.integer  "payer_id"
    t.integer  "operator_id"
    t.float    "amount"
    t.float    "overage"
    t.integer  "order_id"
    t.string   "state"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "order_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "order_amount"
    t.float    "ship_amount"
    t.float    "price",        :default => 0.0, :null => false
    t.float    "order_sum",    :default => 0.0, :null => false
    t.float    "ship_sum",     :default => 0.0, :null => false
    t.float    "cost",         :default => 0.0, :null => false
    t.float    "cost_sum",     :default => 0.0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "sn"
    t.integer  "user_id"
    t.text     "desc"
    t.string   "state"
    t.float    "order_sum",  :default => 0.0, :null => false
    t.float    "ship_sum",   :default => 0.0, :null => false
    t.float    "cost",       :default => 0.0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "orders", ["sn"], :name => "index_orders_on_sn"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

# Could not dump table "payments" because of following StandardError
#   Unknown type 'summary' for column 'text'

  create_table "predicts", :force => true do |t|
    t.date     "date"
    t.integer  "user_id"
    t.integer  "product_id"
    t.float    "average_amount"
    t.integer  "order_times"
    t.integer  "order_amount"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "predicts", ["product_id"], :name => "index_predicts_on_product_id"
  add_index "predicts", ["user_id"], :name => "index_predicts_on_user_id"

  create_table "prices", :force => true do |t|
    t.integer  "product_id"
    t.float    "actual_cost",   :default => 0.0, :null => false
    t.float    "forecast_cost", :default => 0.0, :null => false
    t.date     "date"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "sn"
    t.string   "name"
    t.string   "aliases"
    t.string   "type"
    t.string   "amounts"
    t.string   "state"
    t.integer  "series",     :default => 1
    t.float    "cost",       :default => 0.0, :null => false
    t.text     "des"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "no"
    t.integer  "classify"
    t.string   "market_area"
    t.integer  "market_sort"
    t.string   "unit"
  end

  create_table "search_histories", :force => true do |t|
    t.integer  "user_id"
    t.string   "keywords"
    t.string   "has_result"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "search_histories", ["user_id"], :name => "index_search_histories_on_user_id"

  create_table "ships", :force => true do |t|
    t.string   "sn"
    t.integer  "order_id"
    t.integer  "order_item_id"
    t.integer  "product_id"
    t.float    "amount",        :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "password"
    t.string   "county"
    t.string   "towns"
    t.string   "street"
    t.string   "house"
    t.float    "latitude"
    t.string   "longitude"
    t.string   "state"
    t.string   "validate_code"
    t.string   "token"
    t.integer  "level",         :default => 1
    t.string   "role"
    t.text     "desc"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "baidu_user_id"
  end

end
