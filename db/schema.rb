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

ActiveRecord::Schema.define(:version => 20120409145529) do

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

  create_table "accounts_roles", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "role_id"
  end

  add_index "accounts_roles", ["account_id"], :name => "index_accounts_roles_on_account_id"
  add_index "accounts_roles", ["role_id"], :name => "index_accounts_roles_on_role_id"

  create_table "comments", :force => true do |t|
    t.integer  "notification_id"
    t.integer  "author_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",         :default => false
    t.integer  "parent_id"
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["notification_id"], :name => "index_comments_on_notification_id"
  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"

  create_table "credit_histories", :force => true do |t|
    t.integer  "credit_id"
    t.integer  "credit_datable_id"
    t.string   "credit_datable_type"
    t.integer  "credit_quantity"
    t.decimal  "price",               :precision => 5, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_histories", ["credit_datable_id"], :name => "index_credit_histories_on_credit_datable_id"
  add_index "credit_histories", ["credit_id"], :name => "index_credit_histories_on_credit_id"

  create_table "credits", :force => true do |t|
    t.integer "creditable_id"
    t.string  "creditable_type"
    t.integer "credit"
  end

  add_index "credits", ["creditable_id"], :name => "index_credits_on_creditable_id"

  create_table "external_sources", :force => true do |t|
    t.integer  "google_alert_feed_id"
    t.string   "url"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "view",                 :default => false
    t.string   "google_url"
  end

  add_index "external_sources", ["google_alert_feed_id"], :name => "index_external_sources_on_google_alert_feed_id"

  create_table "filters", :force => true do |t|
    t.integer  "service_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "google_alert_feeds", :force => true do |t|
    t.integer  "service_id"
    t.string   "feed_url"
    t.string   "search_key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "google_alert_feeds", ["service_id"], :name => "index_google_alert_feeds_on_service_id"

  create_table "ideas", :force => true do |t|
    t.integer  "account_id"
    t.string   "search_string"
    t.text     "suggestion"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ideas", ["account_id"], :name => "index_ideas_on_account_id"

  create_table "notices", :force => true do |t|
    t.integer  "notification_id"
    t.boolean  "read",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "new",               :default => true
    t.boolean  "sufficient_credit", :default => true
  end

  add_index "notices", ["notification_id"], :name => "index_notices_on_notification_id"

  create_table "notices_subscriptions", :id => false, :force => true do |t|
    t.integer "notice_id"
    t.integer "subscription_id"
  end

  add_index "notices_subscriptions", ["notice_id"], :name => "index_notices_subscriptions_on_notice_id"
  add_index "notices_subscriptions", ["subscription_id"], :name => "index_notices_subscriptions_on_subscription_id"

  create_table "notifications", :force => true do |t|
    t.string   "title"
    t.string   "sms"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",             :default => false
    t.datetime "published_at"
    t.string   "slug"
    t.integer  "notificationable_id"
    t.string   "notificationable_type"
    t.date     "available_until"
  end

  add_index "notifications", ["slug"], :name => "index_notifications_on_slug", :unique => true

  create_table "notifications_selections", :id => false, :force => true do |t|
    t.integer "notification_id"
    t.integer "selection_id"
  end

  add_index "notifications_selections", ["notification_id"], :name => "index_notifications_selections_on_notification_id"
  add_index "notifications_selections", ["selection_id"], :name => "index_notifications_selections_on_selection_id"

  create_table "payment_type_selections", :force => true do |t|
    t.integer  "payment_type_id"
    t.integer  "credit"
    t.decimal  "price",           :precision => 10, :scale => 0
    t.boolean  "active",                                         :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "selections", :force => true do |t|
    t.integer  "filter_id"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "service_prices", :force => true do |t|
    t.integer  "service_id"
    t.integer  "sender_credit",   :default => 0
    t.integer  "receiver_credit", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.integer  "owner_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "image"
  end

  add_index "services", ["slug"], :name => "index_services_on_slug", :unique => true

  create_table "services_notifications", :force => true do |t|
    t.integer  "notification_id"
    t.integer  "service_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "services_notifications", ["notification_id"], :name => "index_services_notifications_on_notification_id"
  add_index "services_notifications", ["service_id"], :name => "index_services_notifications_on_service_id"

  create_table "services_notifications_selections", :id => false, :force => true do |t|
    t.integer "services_notification_id"
    t.integer "selection_id"
  end

  add_index "services_notifications_selections", ["selection_id"], :name => "services_notification_selection_id_index"
  add_index "services_notifications_selections", ["services_notification_id"], :name => "services_notification_id_index"

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
