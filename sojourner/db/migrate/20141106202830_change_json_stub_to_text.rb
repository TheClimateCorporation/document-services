class ChangeJsonStubToText < ActiveRecord::Migration
  def up
    change_column :template_schemas, :schema_json, :text
    change_column :template_schemas, :json_stub, :text
  end

  def down
    change_column :template_schemas, :schema_json, :string
    change_column :template_schemas, :json_stub, :string
  end
end
