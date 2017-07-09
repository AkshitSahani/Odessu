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

ActiveRecord::Schema.define(version: 20170709211458) do

  create_table "conversations", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["author_id"], name: "index_conversations_on_author_id"
    t.index ["receiver_id"], name: "index_conversations_on_receiver_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "author_id"
    t.integer  "receiver_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["author_id"], name: "index_messages_on_author_id"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "quantity"
    t.decimal  "unit_price"
  end

  create_table "order_reviews", force: :cascade do |t|
    t.integer  "order_id"
    t.text     "review"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_staus", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "order_total"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "store_id"
    t.string   "name"
    t.integer  "price"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "store_name"
    t.string   "address"
    t.string   "store_size"
    t.string   "type"
    t.string   "size_min"
    t.string   "size_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "address"
    t.string   "age_range"
    t.string   "height"
    t.string   "weight"
    t.string   "bust"
    t.string   "hip"
    t.string   "waist"
    t.string   "account_type"
    t.string   "tops_store"
    t.string   "tops_size"
    t.string   "tops_store_fit"
    t.string   "bottoms_store"
    t.string   "bottoms_size"
    t.string   "bottoms_store_fit"
    t.string   "bra_size"
    t.string   "bra_cup"
    t.string   "body_shape"
    t.string   "tops_fit"
    t.string   "bottoms_fit"
    t.string   "preference"
    t.string   "zip_code"
    t.string   "birthdate"
    t.string   "advertisement_source"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "wish_list_items", force: :cascade do |t|
    t.integer  "wish_list_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "product_id"
  end

  create_table "wish_lists", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
