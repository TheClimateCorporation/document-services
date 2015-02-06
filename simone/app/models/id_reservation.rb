class IdReservation < ActiveRecord::Base

  before_validation(on: :create) { generate_id }
  validates :document_id, presence: true, uniqueness: true

  has_one :document,
          foreign_key: :document_id,
          primary_key: :document_id

  default_scope lambda { where(enabled: true) }

  scope :expired, lambda {
    select("id_reservations.*, documents.document_id").
    joins("LEFT OUTER JOIN documents ON(documents.document_id = id_reservations.document_id)").
    where(enabled: true).
    where("id_reservations.updated_at < ?", 1.day.ago).
    where("documents.document_id IS NULL")
  }

  def used?
    document && document.persisted?
  end

  def disable
    self.enabled = false
    save
  end

  private

  # The document_id.nil? check is to allow us to create new records with forced
  # document_ids in the event of a nightmare scenario.
  def generate_id
    self.document_id = SecureRandom.uuid if self.document_id.nil?
  end
end
