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
