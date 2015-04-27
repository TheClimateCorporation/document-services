# The Climate Corporation licenses this file to you under under the Apache
# License, Version 2.0 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.  Unless required by applicable law or agreed
# to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.  See the License for the specific language governing permissions
# and limitations under the License.
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
