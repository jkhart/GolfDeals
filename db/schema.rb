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

ActiveRecord::Schema.define(:version => 20110904212211) do

  create_table "deals", :force => true do |t|
    t.integer  "golf_course_id"
    t.datetime "tee_time"
    t.string   "url"
    t.float    "cost_per_player"
    t.integer  "minimum_players"
    t.integer  "maximum_players"
    t.integer  "percentage_savings"
    t.text     "details"
    t.boolean  "includes_cart"
    t.integer  "number_of_holes"
    t.boolean  "includes_practice_balls"
    t.boolean  "includes_gps"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "golf_courses", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "golfnow_url"
    t.string   "website_url"
    t.string   "phone"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
