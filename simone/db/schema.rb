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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141022175754) do

  create_table "documents", force: true do |t|
    t.string   "document_id",                   null: false
    t.string   "created_by",                    null: false
    t.string   "owner_id",                      null: false
    t.string   "owner_type",   default: "User", null: false
    t.integer  "size_bytes"
    t.string   "content_hash"
    t.string   "uri",                           null: false
    t.string   "type",                          null: false
    t.string   "name",                          null: false
    t.string   "mime_type"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["created_by"], name: "index_documents_on_created_by", using: :btree
  add_index "documents", ["document_id"], name: "index_documents_on_document_id", unique: true, using: :btree
  add_index "documents", ["owner_id"], name: "index_documents_on_owner_id", using: :btree

  create_table "id_reservations", force: true do |t|
    t.string   "document_id",                null: false
    t.boolean  "enabled",     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "id_reservations", ["document_id"], name: "index_id_reservations_on_document_id", unique: true, using: :btree
  add_index "id_reservations", ["enabled"], name: "index_id_reservations_on_enabled", using: :btree

end
