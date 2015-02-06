class GenerationMetadata < ActiveRecord::Base
  attr_accessor :schema_id
  attr_writer :as_production

  validates :document_name, presence: true

  validates :template_id, presence: true
  validate :template_exists, if: :template_id

  validates :schema_id, presence: true

  validate :template_version_can_be_fetched, if: :template

  validates :input_data, presence: true
  validates :input_data, json: true, if: :input_data_valid?
  validate  :input_data_matches_schema,
    if: [:fetch_template_version_used, :input_data_valid?]

  belongs_to :template

  has_one :input_data_location,
          as: :storable,
          class_name: "StorageLocation"

  before_save do
    self.document_id ||= DocstoreConnector
      .new(request_id: request_id)
      .create_id_reservation
  end

  def as_production
    @as_production ||= Rails.env.production?
  end

  def input_data
    @input_data ||= input_data_location.try(:open) { |f| f.read }
  end

  def input_data=(value)
    build_input_data_location(
      type: StorageLocation::DEFAULT_TYPE[Rails.env]
    ) if value && input_data_location.nil?

    input_data_location.try(:file=, value ? StringIO.new(value) : nil)
    @input_data = value
  end

  def fetch_template_version_used
    begin
      fetch_template_version_used!
    rescue ActiveRecord::RecordNotFound => e
      nil
    end
  end

  def fetch_template_version_used!
    return nil unless template

    @fetched_template_version ||= version_used ?
      template.version!(version_used) :
      template.version!(
        schema_id: schema_id,
        version: version_specified,
        as_production: as_production
      ).tap { |tv| self.version_used = tv.try(:version) }
  end

  #TODO: change schema so default owner_type is "User" rather than "user"
  # so that it matches docstore

  # required as storable
  def key_prefix
    "input_data"
  end

  # required as storable
  def file_extension
    "json"
  end

  private

  def template_exists
    unless template
      errors[:template_id] << "doesn't correspond to an existing template"
    end
  end

  def template_version_can_be_fetched
    begin
      fetch_template_version_used!
    rescue Exception => e
      errors[:version_used] << e.to_s
    end
  end

  def input_data_matches_schema
    input_data_errors = fetch_template_version_used.validate_input_data(input_data)
    errors[:input_data].concat(input_data_errors) if input_data_errors.present?
  end

  def input_data_valid?
    errors[:input_data].blank?
  end
end
