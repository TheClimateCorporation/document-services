class TemplateSchema < ActiveRecord::Base
  acts_as_paranoid

  validates :name, presence: true

  validates :json_schema_properties, presence: true
  with_options if: :json_schema_properties_valid? do |template_schema|
    template_schema.validates :json_schema_properties, json: true
    template_schema.validate  :json_schema_properties_includes_root_property
    template_schema.validate  :json_schema_properties_doesnt_include_ids
    template_schema.validates :json_schema_properties, json: {
      as_schema: true,
      value: :json_schema
    }

    template_schema.validates :json_stub, json: {
      schema: ->(record) { MultiJson.load(record.json_schema) }
    }, allow_blank: true
  end

  validates :json_stub, presence: true

  validates :created_by, presence: true

  has_many :template_single_versions

  def self.new_clone(template_schema)
    new(
      template_schema.attributes.slice("json_schema_properties", "json_stub")
        .merge(name: "CLONE OF #{template_schema.name} (edit me)")
    )
  end

  def json_schema
    schema = {type: :object, additionalProperties: false}

    properties = MultiJson.try(:load, json_schema_properties)
    root = properties.try(:keys).try(:first)

    schema[:required] = [root] if root
    schema[:properties] = properties if properties

    schema.to_json
  end

  def immutable?
    persisted? && !template_single_versions.empty?
  end

  private

  def json_schema_properties_valid?
    errors[:json_schema_properties].blank?
  end

  def json_schema_properties_includes_root_property
    properties = MultiJson.load(json_schema_properties)
    unless properties.is_a?(Hash) && properties.length == 1
      errors[:json_schema_properties] << "must include exactly one root element"
    end
  end

  def json_schema_properties_doesnt_include_ids
    if json_schema_properties =~ /"id":/
      errors[:json_schema_properties] << "'id' attribute is not supported"
    end
  end
end
