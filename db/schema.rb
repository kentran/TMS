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

ActiveRecord::Schema.define(:version => 20131121042100) do

  create_table "activity_logs", :force => true do |t|
    t.string   "user_id"
    t.string   "browser"
    t.string   "ip_addr"
    t.string   "controller"
    t.string   "action"
    t.text     "params"
    t.string   "note"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "university_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.text     "format"
    t.date     "deadline",      :default => '2013-11-21'
  end

  add_index "departments", ["university_id"], :name => "index_departments_on_university_id"

  create_table "notifications", :force => true do |t|
    t.string   "recipient"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "sender"
    t.boolean  "is_view",    :default => false
    t.string   "content",    :default => "My files are ready"
  end

  add_index "notifications", ["project_id"], :name => "index_notifications_on_project_id"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "project_files", :force => true do |t|
    t.string   "file_name"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "file_path"
    t.string   "original_file_name"
    t.boolean  "primary_file",       :default => false, :null => false
  end

  add_index "project_files", ["project_id"], :name => "index_project_files_on_project_id"
  add_index "project_files", ["user_id"], :name => "index_project_files_on_user_id"

  create_table "project_references", :force => true do |t|
    t.string   "reference_source"
    t.string   "reference_url"
    t.text     "content"
    t.integer  "project_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "author"
    t.string   "publisher"
    t.string   "year"
  end

  add_index "project_references", ["project_id"], :name => "index_project_references_on_project_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "abstract"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "deadline"
    t.string   "version"
  end

  create_table "projects_users", :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  add_index "projects_users", ["project_id", "user_id"], :name => "by_project_and_user", :unique => true

  create_table "reminders", :force => true do |t|
    t.string   "recipient"
    t.date     "date"
    t.string   "subject"
    t.integer  "user_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "status",     :default => "Pending"
  end

  add_index "reminders", ["user_id"], :name => "index_reminders_on_user_id"

  create_table "universities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.integer  "university_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "role"
    t.boolean  "notif_on",               :default => true,  :null => false
    t.boolean  "reminder_on",            :default => true,  :null => false
    t.boolean  "upload_confirm_on",      :default => false, :null => false
    t.integer  "department_id"
  end

  add_index "users", ["department_id"], :name => "index_users_on_department_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["university_id"], :name => "index_users_on_university_id"

end
