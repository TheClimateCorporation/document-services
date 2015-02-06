class StorageLocation < ActiveRecord::Base
  attr_reader :file

  # so we can store whatever we want
  # TemplateSingleVersion (file) file_location
  # GenerationMetadata (input_data) input_data_location
  # SampleDocument (file) file_location
  belongs_to :storable, polymorphic: true

  before_create do
    set_uri
    put!
  end
  after_create ->{ file.try(:close) }

  validate :no_local_storage_in_production
  validates :type, :file, presence: true

  validates :uri, presence: true, if: :persisted?
  validate  :file_is_saved, if: :persisted?

  DEFAULT_TYPE = Hash.new("S3Location").merge(
    "development" => "LocalStorageLocation",
    "test"        => "NullLocation"
  )

  #Methods the subclasses promise to have:

  # does something exist at the specified uri?
  def file_saved?
    raise "Subclass needs to implement this"
  end

  def file=(value)
    @file.try(:close) # Close prev file stream if any
    @file = value
  end

  def read_link
    raise "Subclass needs to implement this"
  end

  def key
    # set_uri runs *after* validations, which means there WILL be a storable.
    "#{storable_type}_#{storable_id}.#{storable.file_extension}"
  end

  def open
    raise "Subclass needs to implement this"
  end

  private

  def no_local_storage_in_production
    if (self.type == "LocalStorageLocation" && Rails.env.production?)
      self.errors.add(:base, "Local storage not allowed in production, " \
        "use S3Location.")
      FileUtils.rm(self.uri) if file_saved?
    end
  end

  def set_uri
    # base uri is set different in the different storage types
    raise "Subclass needs to implement this"
  end

  # will save the file to the location even if
  # something else is already written there
  def put!
    raise "Subclass needs to implement this"
  end

  def file_is_saved
    self.errors.add(:file, "is not saved!") unless file_saved?
  end

end
