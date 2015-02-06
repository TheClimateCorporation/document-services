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
