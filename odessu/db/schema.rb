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

ActiveRecord::Schema.define(version: 20170722182512) do

  create_table "conversations", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["author_id"], name: "index_conversations_on_author_id"
    t.index ["receiver_id"], name: "index_conversations_on_receiver_id"
  end

  create_table "insecurities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "insecurity_top"
    t.string   "insecurity_bottom"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "issues", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
    t.string   "issue_fit"
    t.string   "issue_length"
    t.string   "other1"
    t.string   "other2"
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
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "quantity"
    t.float    "unit_price"
    t.float    "total_price"
  end

  create_table "order_reviews", force: :cascade do |t|
    t.integer  "order_id"
    t.text     "review"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_statuses", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "order_total"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "order_status_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "tops"
    t.string "tops_href"
    t.string "dresses"
    t.string "dresses_href"
    t.string "bottoms"
    t.string "bottoms_href"
    t.string "outwear"
    t.string "outwear_href"
    t.string "swimwear"
    t.string "swimwear_href"
    t.string "link"
    t.string "link_href"
    t.string "shorts"
    t.string "skirts"
    t.string "leggings"
    t.string "activewear"
    t.string "jumpsuit"
    t.string "jumpsuit_href"
    t.string "name"
    t.string "picture_src"
    t.string "priceall"
    t.string "pricebefore"
    t.string "priceafter"
    t.string "description1"
    t.string "description2"
    t.string "description3"
    t.string "description4"
    t.string "description5"
    t.string "color"
    t.string "size"
    t.string "itemcode"
  end

  create_table "showoffs", force: :cascade do |t|
    t.string   "showoff"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "store_name"
    t.string   "address"
    t.string   "store_size"
    t.string   "size_min"
    t.string   "size_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "feature"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                      default: "",    null: false
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",            default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "address"
    t.string   "age_range"
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
    t.string   "preference"
    t.string   "bottoms_fit"
    t.string   "birthdate"
    t.string   "advertisement_source"
    t.string   "weight_type"
    t.integer  "height_ft"
    t.integer  "height_in"
    t.integer  "height_cm"
    t.float    "predicted_hip"
    t.float    "predicted_waist"
    t.float    "predicted_bust"
    t.string   "bust_waist_hip_inseam_type"
    t.string   "inseam"
    t.string   "full_name"
    t.string   "phone_number"
    t.string   "stripe_customer_id"
    t.boolean  "email_subscription",         default: false
    t.boolean  "terms_agreed?",              default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
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
