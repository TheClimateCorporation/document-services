class TemplateSingleVersion < ActiveRecord::Base
  attr_accessor :file, :ready_for_prod, :storage_type

  belongs_to :template

  # schemas can be associated with multiple templates.
  belongs_to :template_schema

  has_one :sample_document, as: :template_version

  has_one :file_location,
          as: :storable,
          class_name: "StorageLocation"

  has_many :permission_changes,
           as: :template_version,
           class_name: "TemplatePermissionChange"

  before_validation do
    ensure_version
    ensure_permissions
    ensure_file_location
  end

  validates :template,
            :template_schema,
            :created_by,
            :version,
            :permission_changes,
            :file_location,
            :file,
            presence: true

  validates :version, uniqueness: { scope: :template_id }
  validate :ensure_contiguous_versions

  delegate :file_saved?, to: :file_location

  after_initialize do
    @ready_for_prod ||= false
    @storage_type ||= StorageLocation::DEFAULT_TYPE[Rails.env]
  end

  def ready_for_production?
    permission_changes.order(created_at: :desc)
                      .limit(1)
                      .pluck(:ready_for_production)
                      .pop
  end

  def validate_input_data(input_data)
    schema = MultiJson.load(template_schema.json_schema)
    JSON::Validator.fully_validate(schema, input_data)
  end

  def render(input_data)
    template_file_stream = file_location.open.to_inputstream
    renderer = Java::WindwardTemplateRenderer.new(template_file_stream)

    input_data_root, input_data_body = MultiJson.load(input_data).first
    xml_input_data_stream = StringIO.new(
      input_data_body.to_xml(dasherize: false, root: input_data_root)
    ).to_inputstream

    document = Tempfile.new('document')
    document_stream = document.to_outputstream

    renderer.render(xml_input_data_stream, document_stream)

    document.open # Re-open in read mode
  end

  # required as storable
  def key_prefix
    "templates"
  end

  # required as storable
  def file_extension
    "docx"
  end

  private

  def ensure_version
    self.version ||= (template.versions.maximum(:version) || 0) + 1
  end

  def ensure_permissions
    self.permission_changes.new(
      ready_for_production: !!@ready_for_prod,
      created_by: self.created_by
    ) if self.permission_changes.empty?
  end

  def ensure_file_location
    self.build_file_location(
      file: file,
      type: storage_type
    ) if self.file_location.nil?
  end

  def ensure_contiguous_versions
    sibs = template.versions.pluck(:version) << self.version
    sibs.sort.each_with_index do |v, idx|
      unless (v == idx + 1)
        errors[:version] << "Can't skip version numbers"
      end
    end
  end

end
