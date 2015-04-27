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

RSpec.describe "SampleDocument generation requests", :type => :request do
  subject { response }
  before { request_as(1337) }

  describe "POST /generate" do
    let(:template_schema) { create(:template_schema, json_stub: {root: {body: ['item']}}.to_json) }
    let(:tsv) { create(:template_single_version, template_schema: template_schema) }

    context "if the document saves correctly" do
      before do
        post "templates/#{tsv.template_id}/v/#{tsv.version}/sample_document"
      end

      it { is_expected.to redirect_to("/templates/#{tsv.template_id}/v/#{tsv.version}")}

    end

    context "if an error occurs in saving the sample document" do
      before do
        post "templates/#{tsv.template_id}/v/#{tsv.version}/sample_document"
        #second time should fail
        post "templates/#{tsv.template_id}/v/#{tsv.version}/sample_document"
      end

      it "redirects with an error message" do
        is_expected.to redirect_to("/templates/#{tsv.template_id}/v/#{tsv.version}")
        expect(flash['alert']).to eq({:template_version_id=>["the template_version " \
          "already has a sample document"]})
      end

    end
  end

end
