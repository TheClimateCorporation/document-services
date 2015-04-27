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

RSpec.describe SampleDocument, :type => :model do

  it { is_expected.to validate_presence_of :file_location }
  it { is_expected.to validate_presence_of :template_version }

  describe "generate_new_sample" do
    let(:tsv) { create(:template_single_version) }

    subject { SampleDocument.generate_new_sample(tsv) }

    before do
      allow_any_instance_of(TemplateSingleVersion)
        .to receive(:render)
        .and_return(instance_double('Tempfile'))
    end

    it "creates a new sample_document" do
      expect(subject).to be_an_instance_of(SampleDocument)
      expect {
        subject.save!
      }.not_to raise_error
    end

    it "does not allow creation of a duplicate sample" do
      subject.save
      new_sample = SampleDocument.generate_new_sample(tsv)
      expect { new_sample.save! }.to raise_error
      expect(new_sample.errors.messages).to include({:template_version_id => ["the template_version" \
        " already has a sample document"]})
    end

  end
end
