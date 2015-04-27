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
class ChangeVersionSpecifiedToNullableForGenerationMetadata < ActiveRecord::Migration
  def up
    change_column :generation_metadata, :version_specified, :string, null: true
    execute "UPDATE generation_metadata SET version_specified = NULL WHERE version_specified = 'lastest'"
    change_column :generation_metadata, :version_specified, :integer
  end

  def down
    change_column :generation_metadata, :version_specified, :string
    execute "UPDATE generation_metadata SET version_specified = 'lastest' WHERE version_specified IS NULL"
    change_column :generation_metadata, :version_specified, :string, null: false
  end
end
