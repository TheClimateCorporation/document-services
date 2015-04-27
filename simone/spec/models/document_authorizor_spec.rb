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

RSpec.describe DocumentAuthorizor, :type => :model do

  describe "self.authorized?" do
    context "when the document owner_type is 'anyone' " do
      let(:anyone_doc) { create(:document, owner_type: 'anyone') }

      it "allows read" do
        expect(DocumentAuthorizor.authorized?(anyone_doc, SecureRandom.hex(8), :read))
          .to eq(true)
      end
    end

    context "when the document owner_type is 'user' " do
      let(:user_doc) { create(:document, owner_type: 'user') }

      it "allows read if the requestor is the document owner" do
        expect(DocumentAuthorizor.authorized?(user_doc, user_doc.owner_id, :read))
          .to eq(true)
      end

      it "allows read if the requestor is the document creator" do
        expect(DocumentAuthorizor.authorized?(user_doc, user_doc.created_by, :read))
          .to eq(true)
      end

      it "does not allow read for anyone else" do
        expect(DocumentAuthorizor.authorized?(user_doc, SecureRandom.hex(8), :read))
          .to eq(false)
      end
    end
  end
end
