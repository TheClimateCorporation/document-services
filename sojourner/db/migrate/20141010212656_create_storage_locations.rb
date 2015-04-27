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
class CreateStorageLocations < ActiveRecord::Migration
  def change
    create_table :storage_locations do |t|
      t.string :type, null: false
      t.string :uri, null: false
      t.integer :storable_id, null: false
      t.string :storable_type, null: false

      t.timestamps
    end
  end
end
