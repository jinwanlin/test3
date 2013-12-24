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

ActiveRecord::Schema.define(:version => 20131222021745) do

  create_table "order_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.float    "price"
    t.integer  "order_amount"
    t.float    "ship_amount"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "sn"
    t.integer  "user_id"
    t.text     "desc"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "orders", ["sn"], :name => "index_orders_on_sn"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "prices", :force => true do |t|
    t.integer  "product_id"
    t.float    "purchase_low_price"
    t.float    "purchase_price"
    t.float    "purchase_heigh_price"
    t.float    "selling_price"
    t.date     "date"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "des"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "phone"
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
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "desc"
  end

end
