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
class TemplateSingle < Template
  has_many :versions,
           foreign_key: "template_id",
           class_name: "TemplateSingleVersion"

  private

  def version_from_options(opts = {})
    raise ArgumentError, "schema_id was not provided" unless opts[:schema_id]

    vs = versions.where(template_schema_id: opts[:schema_id])
    unless vs.exists?
      raise ActiveRecord::RecordNotFound, "doesn't exist for schema_id #{opts[:schema_id]}"
    end

    if opts[:version]
      unless versions.where(version: opts[:version]).exists?
        raise ActiveRecord::RecordNotFound, "doesn't exist for version #{opts[:version]}"
      end

      vs = vs.where(version: opts[:version])
      unless vs.where(version: opts[:version]).exists?
        raise ActiveRecord::RecordNotFound, "doesn't exist for version #{opts[:version]} and schema_id #{opts[:schema_id]}"
      end
    end

    if opts[:as_production]
      vs = vs.select(&:ready_for_production?)
      if vs.empty?
        raise ActiveRecord::RecordNotFound, "is not available in production"
      end
    end

    vs.last
  end
end
