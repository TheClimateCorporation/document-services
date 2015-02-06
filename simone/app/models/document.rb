class Document < ActiveRecord::Base
  # MOST document behavior should be here. Only differences
  # in file write and retrieval should be in subclasses
  attr_accessor :file

  belongs_to :reservation,
             class_name: "IdReservation",
             foreign_key: :document_id,
             primary_key: :document_id

  validate :no_local_storage_in_production
  validate :check_reservation
  validates :file,
            :type,
            :reservation,
            :name,
            presence: true

  before_create do
    ensure_owner_id
    set_uri
    put!
  end

  validate :file_is_saved, if: :persisted?

  DEFAULT_TYPE = Hash.new("S3Document").merge(
    "development" => "LocalDocument",
    "test" => "LocalDocument"
  )

  # will return an empty string if mime_type is nil.
  def file_extension
    @file_extension ||= Rack::Mime::MIME_TYPES.invert[self.mime_type]
  end

  def file_content
    file && file.read
  end

  def read_link
    raise "Subclass needs to implement this"
  end

  def file_saved?
    raise "Subclass needs to implement this"
  end

  private

  def no_local_storage_in_production
    if (self.type == "LocalDocument" && Rails.env.production?)
      self.errors.add(:base, "Local storage not allowed in production, " \
        "use S3Document.")
      FileUtils.rm(self.uri) if file_saved?
    end
  end

  def check_reservation
    if document_id.nil? && reservation.nil?
      self.reservation = IdReservation.create
    elsif document_id && reservation.nil?
      errors.add(:document_id, "was specified but does not refer to a valid IdReservation")
    elsif reservation && reservation.used? && (reservation.document != self)
      errors.add(:document_id, "refers to an IdReservation which has already been used")
    end
  end

  def ensure_owner_id
    self.owner_id ||= self.created_by
  end

  def set_uri
    raise "Subclass needs to implement this"
  end

  def put!
    raise "Subclass needs to implement this"
  end

  def file_is_saved
    self.errors.add(:file, "is not saved!") unless file_saved?
  end
end
