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

ActiveRecord::Schema.define(version: 20150203013742) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "generation_metadata", force: true do |t|
    t.integer  "template_id",                          null: false
    t.integer  "version_specified"
    t.integer  "version_used",                         null: false
    t.string   "request_id",                           null: false
    t.string   "created_by",                           null: false
    t.string   "document_owner_id"
    t.string   "document_id",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_owner_type", default: "user", null: false
    t.string   "document_name",                        null: false
    t.string   "publisher_key"
  end

  create_table "sample_documents", force: true do |t|
    t.integer  "template_version_id",   null: false
    t.string   "template_version_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sample_documents", ["template_version_id"], name: "index_sample_documents_on_template_version_id", using: :btree

  create_table "storage_locations", force: true do |t|
    t.string   "type",          null: false
    t.string   "uri",           null: false
    t.integer  "storable_id",   null: false
    t.string   "storable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storage_locations", ["storable_id"], name: "index_storage_locations_on_storable_id", using: :btree
  add_index "storage_locations", ["uri"], name: "index_storage_locations_on_uri", unique: true, using: :btree

  create_table "template_permission_changes", force: true do |t|
    t.integer  "template_version_id",   null: false
    t.string   "template_version_type", null: false
    t.boolean  "ready_for_production",  null: false
    t.string   "created_by",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "template_permission_changes", ["template_version_id"], name: "index_template_permission_changes_on_template_version_id", using: :btree

  create_table "template_schemas", force: true do |t|
    t.string   "name",                   null: false
    t.text     "json_stub",              null: false
    t.string   "created_by",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.text     "json_schema_properties", null: false
  end

  add_index "template_schemas", ["deleted_at"], name: "index_template_schemas_on_deleted_at", using: :btree

  create_table "template_single_versions", force: true do |t|
    t.integer  "template_id",        null: false
    t.integer  "version",            null: false
    t.integer  "template_schema_id", null: false
    t.string   "created_by",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "template_single_versions", ["template_id", "version"], name: "index_template_single_versions_on_template_id_and_version", unique: true, using: :btree
  add_index "template_single_versions", ["template_id"], name: "index_template_single_versions_on_template_id", using: :btree
  add_index "template_single_versions", ["template_schema_id"], name: "index_template_single_versions_on_template_schema_id", using: :btree

  create_table "templates", force: true do |t|
    t.string   "name",       null: false
    t.string   "type",       null: false
    t.string   "created_by", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
