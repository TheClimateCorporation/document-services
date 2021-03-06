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

RSpec.describe Document, :type => :model do

  subject { create(:document, :local_document) }
  let!(:resv) { IdReservation.create! }

  it "creates a reservation if one isn't given" do
    expect{ subject.save! }.to change { IdReservation.count }.by 1
  end

  it 'can use a reservation object' do
    doc = build(:document, document_id: resv.document_id)

    expect{ doc.save! }.to_not change { IdReservation.count }
    expect(doc.reload.document_id).to eq resv.document_id
  end

  it "will set the uri" do
    subject.save
    expected_uri = [
      subject.send(:default_directory),
      subject.document_id,
      "#{subject.name}#{subject.file_extension}"
    ].join('/')
    expect(subject.uri).to eq expected_uri
  end

  it "will save the file before creating the record" do
    file = File.open('spec/fixtures/empty.pdf')

    subject.file = file
    subject.save

    file.close

    expect(IO.binread(subject.uri))
      .to eq(IO.binread('spec/fixtures/empty.pdf'))
  end

  describe "file_saved?" do
    it "tells you if there's something at the uri" do
      expect(File).to receive(:exists?).with(subject.uri)
      subject.file_saved?
    end
  end

  describe "file_is_saved" do
    it "checks if the file is saved" do
      expect(File).to receive(:exists?).with(subject.uri)
      subject.send(:file_is_saved)
    end
  end

  describe "read_link" do
    it "returns url fragment to access the stored content from the rails host" do
      expect(subject.read_link)
        .to eq("documents/#{subject.document_id}/#{subject.name}#{subject.file_extension}")
    end
  end
end
