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

ActiveRecord::Schema.define(:version => 20111117121439) do

  create_table "accounts", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  add_index "accounts", ["reset_password_token"], :name => "index_accounts_on_reset_password_token", :unique => true

  create_table "filters", :force => true do |t|
    t.integer  "service_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "service_id"
    t.string   "title"
    t.string   "sms"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["service_id"], :name => "index_notifications_on_service_id"

  create_table "notifications_selections", :id => false, :force => true do |t|
    t.integer "notification_id"
    t.integer "selection_id"
  end

  add_index "notifications_selections", ["notification_id", "selection_id"], :name => "notification_id_and_selection_id", :unique => true
  add_index "notifications_selections", ["notification_id"], :name => "index_notifications_selections_on_notification_id"
  add_index "notifications_selections", ["selection_id"], :name => "index_notifications_selections_on_selection_id"

  create_table "selections", :force => true do |t|
    t.integer  "filter_id"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_prices", :force => true do |t|
    t.integer  "service_id"
    t.float    "sender_credit",   :default => 0.0
    t.float    "receiver_credit", :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.integer  "owner_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "account_id"
    t.integer  "service_id"
    t.boolean  "email",      :default => false
    t.boolean  "sms",        :default => false
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["account_id"], :name => "index_subscriptions_on_account_id"
  add_index "subscriptions", ["service_id"], :name => "index_subscriptions_on_service_id"

  create_table "subscriptions_selections", :id => false, :force => true do |t|
    t.integer "subscription_id"
    t.integer "selection_id"
  end

  add_index "subscriptions_selections", ["subscription_id"], :name => "index_subscriptions_selections_on_subscription_id"

end
