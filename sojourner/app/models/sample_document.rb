class SampleDocument < ActiveRecord::Base

  belongs_to :template_version, polymorphic: true

  has_one :file_location,
          as: :storable,
          class_name: "StorageLocation"

  validates :template_version,
            :file_location,
            presence: true

  validates :template_version_id, uniqueness: {
    scope: :template_version_type,
    message: "the template_version already has a sample document"
  }

  delegate :file, :file_saved?, :read_link, to: :file_location

  def self.generate_new_sample(template_version, storage_type = nil)
    document = template_version.render(template_version.template_schema.json_stub)

    file_location = StorageLocation.new(
      file: document,
      type: storage_type || StorageLocation::DEFAULT_TYPE[Rails.env]
    )

    new(
      template_version: template_version,
      file_location: file_location
    )
  end

  # required as storable
  def key_prefix
    "sample_documents"
  end

  # required as storable
  def file_extension
    "pdf"
  end

end
