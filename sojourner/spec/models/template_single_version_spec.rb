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

RSpec.describe TemplateSingleVersion, :type => :model do
  let(:subject) { create(:template_single_version) }

  it "has a file_location" do
    expect(subject.file_location).not_to be_nil
  end

  describe "#ready_for_production" do
    context "right after creation" do
      it "flags ready_for_production as false when first created" do
        expect(subject.ready_for_production?).to eq(false)
      end
    end

    context "after additional permissions are added" do
      it "returns the most recent permission state" do
        subject.permission_changes.create(
          ready_for_production: true,
          created_by: subject.created_by,
          created_at: Time.now + 1
        )

        expect(subject.ready_for_production?).to be(true)
      end
    end
  end

  context "as a storable" do
    it "knows a key prefix" do
      expect(subject.key_prefix).to eq("templates")
    end

    it "knows a file extension" do
      expect(subject.file_extension).to eq("docx")
    end
  end

  describe "#render" do
    let(:template_file_path) { "#{Rails.root}/spec/fixtures/test_template.docx" }
    let(:input_data_file_path) { "#{Rails.root}/spec/fixtures/test_json_stub.json" }

    let(:template_version) do
      create(
        :template_single_version,
        file: File.open(template_file_path),
        storage_type: "LocalStorageLocation"
      )
    end
    let(:input_data) { File.read(input_data_file_path) }

    it "fills the template with the provided input data" do
      rendered = template_version.render(input_data)

      # NOTE: Unfortunately Windward generated PDF files are different from
      # system to system. `spec/fixtures/rendered_test_document.pdf` shows how
      # the rendered file should look like, please compare to generated file.
      expect(rendered.read).to be_present

      rendered.close
    end
  end

  describe "#validate_input_data" do
    it "valdiates given input data against it's template schema" do
      subject.template_schema.json_schema_properties =
        {root: {type: :object, properties: {foo: {type: :string}}}}.to_json
      input_data = {'root' => {'foo' => 1234}}
      expect(subject.validate_input_data(input_data).first).to match(/foo/)
    end
  end
end
