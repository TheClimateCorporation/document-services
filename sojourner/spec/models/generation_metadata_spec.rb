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

RSpec.describe GenerationMetadata, :type => :model do
  it { is_expected.to validate_presence_of(:document_name) }
  it { is_expected.to validate_presence_of(:template_id) }
  it { is_expected.to validate_presence_of(:schema_id) }

  it "validates the existance of the template for the given template_id" do
    expect(Template.where(id: 9999).exists?).to be(false) # Guard

    generation_metadata = build(:generation_metadata, template_id: 9999)
    generation_metadata.valid?

    expect(generation_metadata.errors[:template_id])
      .to include("doesn't correspond to an existing template")
  end

  it "validates that template version can be fetched with the given params" do
    versionless_template = build(:template)
    generation_metadata = build(:generation_metadata, template: versionless_template)

    # Guard
    expect {
      versionless_template.version!(schema_id: generation_metadata.schema_id)
    }.to raise_error

    generation_metadata.valid?
    expect(generation_metadata.errors[:version_used]).to_not be_empty
  end

  it { is_expected.to validate_presence_of(:input_data) }

  it "validates that input data is a json object" do
    generation_metadata = build(:generation_metadata, input_data: "bad json")
    generation_metadata.valid?
    expect(
      generation_metadata.errors[:input_data].first
    ).to match(/unexpected token/)
  end

  it "validates input data" do
    generation_metadata = build(:generation_metadata)
    allow(generation_metadata.fetch_template_version_used)
      .to receive(:validate_input_data)
      .and_return(['oops!'])
    generation_metadata.valid?

    expect(generation_metadata.errors[:input_data]).to include('oops!')
  end

  context "when env is production" do
    it "sets as_production to true" do
      allow(Rails.env).to receive(:production?) { true }
      generation_metadata = build(:generation_metadata, as_production: false)
      expect(generation_metadata.as_production).to be(true)
    end
  end

  context "when env is not production" do
    it "defaults as_production to false" do
      generation_metadata = build(:generation_metadata, as_production: nil)
      expect(generation_metadata.as_production).to be(false)
    end

    it "allows as_production to be set" do
      generation_metadata = build(:generation_metadata, as_production: true)
      expect(generation_metadata.as_production).to be(true)
    end
  end

  it "reserves a document_id if none provided" do
    generation_metadata = build(:generation_metadata, document_id: nil)

    connection_double = instance_double(DocstoreConnector)
    expect(DocstoreConnector).to receive(:new)
      .with(request_id: generation_metadata.request_id)
      .and_return(connection_double)
    expect(connection_double).to receive(:create_id_reservation)
      .and_return('reserved-doc-id')

    generation_metadata.save!
    expect(generation_metadata.document_id).to eq('reserved-doc-id')
  end

  it "persists input_data" do
    # NOTE: Using local storage since default storage doesn't store anything
    generation_metadata = build(
      :generation_metadata,
      input_data_location: build(:storage_location, :local_storage)
    )

    # NOTE: Assigning input_data after input_data_location to avoid chicken egg
    # dilemma
    generation_metadata.input_data = generation_metadata
      .fetch_template_version_used
      .template_schema
      .json_stub
    generation_metadata.save!

    expect(GenerationMetadata.find(generation_metadata.id).input_data)
      .to eq(generation_metadata.input_data)
  end

  describe "#fetch_template_version_used" do
    let(:template_version) { create(:template_single_version) }

    context "when version_used is not set" do
      it "sets version_used to the fetched template version" do
        generation_metadata = build(
          :generation_metadata,
          template: template_version.template,
          schema_id: template_version.template_schema_id
        )

        generation_metadata.fetch_template_version_used
        expect(generation_metadata.version_used).to eq(template_version.version)
      end
    end

    context "when version_used is set" do
      it "returns the template version for template_id and version_used" do
        generation_metadata = build(
          :generation_metadata,
          template: template_version.template,
          version_used: template_version.version
        )

        expect(generation_metadata.fetch_template_version_used)
          .to eq(template_version)
      end
    end
  end
end
