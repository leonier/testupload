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

ActiveRecord::Schema.define(:version => 20160122053211) do

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "sha2"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "attachments", :force => true do |t|
    t.integer  "uptest_id"
    t.integer  "postthread_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "attachments", ["postthread_id"], :name => "index_attachments_on_postthread_id"
  add_index "attachments", ["uptest_id"], :name => "index_attachments_on_uptest_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.datetime "date"
    t.string   "notificationtext"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "isread"
  end

  create_table "postreplies", :force => true do |t|
    t.integer  "postthread_id"
    t.integer  "user_id"
    t.string   "title"
    t.string   "content"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "postthreads", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "uptests", :force => true do |t|
    t.string   "filename"
    t.datetime "uploadtime"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "public"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_hash"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "salt"
    t.string   "nickname"
    t.string   "email"
    t.boolean  "isexternal"
    t.string   "external_type"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

end
