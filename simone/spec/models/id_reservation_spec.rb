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
require 'rails_helper'

RSpec.describe IdReservation, :type => :model do

  let!(:r) { IdReservation.create! }

  it 'generates a uuid' do
    expect(r.document_id).to_not be_nil
  end

  it 'ensures the uuid is uniqe' do
    r2 = IdReservation.new(document_id: r.document_id)
    expect(r2).to_not be_valid
  end

  it 'is enabled by default' do
    expect(r.enabled).to eq true
  end

  it 'does not return non-enabled reservations by default' do
    r = IdReservation.create!(enabled: false)
    expect(IdReservation.last).to_not eq r
  end

  describe "#disaable" do
    it "sets enabled to false" do
      r.disable
      expect(r.enabled).to eq false
    end
  end
end
