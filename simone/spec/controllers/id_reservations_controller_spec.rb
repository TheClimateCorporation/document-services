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

RSpec.describe IdReservationsController, :type => :controller do

  describe "POST #create" do
    it "returns http success" do
      post :create
      expect(response).to be_success
    end
  end

  describe "PUT #disable" do
    let(:r) { IdReservation.create! }

    context "when the document_id is valid" do
      it "returns http success" do
        put :disable, document_id: r.document_id
        expect(response).to be_success
      end
    end

    context "when the document_id is not valid" do
      it "returns bad request" do
        put :disable, document_id: 1234
        expect(response.code).to eq("400")
      end
    end
  end

end
