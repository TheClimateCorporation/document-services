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
class RenameSchemaJsonToJsonSchemaPropertiesInTemplateSchemas < ActiveRecord::Migration
  def up
    unless column_exists?(:template_schemas, :json_schema_properties)
      add_column :template_schemas, :json_schema_properties, :text
    end

    if column_exists?(:template_schemas, :schema_json)
      execute("SELECT id, schema_json FROM template_schemas").each do |template_schema|
        json_schema_properties = begin
          schema = MultiJson.load(template_schema["schema_json"])
          schema.fetch("properties", {}).to_json
        rescue MultiJson::ParseError
          warn "Schema json for template schema ##{template_schema["id"]}" \
               " could not be parsed"

          template_schema["schema_json"] # Use value as is then
        end

        execute <<-SQL
          UPDATE template_schemas
          SET json_schema_properties=#{ActiveRecord::Base.sanitize(json_schema_properties)}
          WHERE id=#{template_schema["id"]}
        SQL
      end

      remove_column :template_schemas, :schema_json
    end

    change_column :template_schemas, :json_schema_properties, :text, null: false
  end

  def down
    unless column_exists?(:template_schemas, :schema_json)
      add_column :template_schemas, :schema_json, :text
    end

    if column_exists?(:template_schemas, :json_schema_properties)
      execute("SELECT id, json_schema_properties FROM template_schemas").each do |template_schema|
        schema_json = begin
          schema_properties = MultiJson.load(template_schema["json_schema_properties"])
          {
            type: :object,
            additionalProperties: false,
            properties: schema_properties,
            required: schema_properties.is_a?(Hash) && schema_properties.present? ?
              [schema_properties.keys.first] : nil
          }.compact.to_json
        rescue MultiJson::ParseError
          warn "Json schema properties for template schema ##{template_schema["id"]}" \
               " could not be parsed"

          template_schema["json_schema_properties"] # Use value as is then
        end

        execute <<-SQL
          UPDATE template_schemas
          SET schema_json=#{ActiveRecord::Base.sanitize(schema_json)}
          WHERE id=#{template_schema["id"]}
        SQL
      end

      remove_column :template_schemas, :json_schema_properties
    end

    change_column :template_schemas, :schema_json, :text, null: false
  end
end
