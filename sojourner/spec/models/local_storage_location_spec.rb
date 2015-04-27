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

RSpec.describe LocalStorageLocation, :type => :model do

  let(:subject) { build(:storage_location, :local_storage) }

  describe "file_saved?" do
    it "tells you if there's something at the uri" do
      expect(File).to receive(:exists?).with(subject.uri)
      subject.file_saved?
    end
  end

  describe "read_link" do
    it "returns url fragment to access the stored content from the rails host" do
      expect(subject.read_link).to eq("/#{subject.storable.key_prefix}/#{subject.key}")
    end
  end

  it "will set the uri" do
    subject.save
    expected_uri = File.join(Rails.root, 'tmp', subject.storable.key_prefix, "#{subject.storable_type}_#{subject.storable_id}.#{subject.storable.file_extension}")
    expect(subject.uri).to eq expected_uri
  end

  it "will save the file before creating the record" do
    file = File.open('spec/fixtures/test_template.docx')

    subject.file = file
    subject.save

    expect(IO.binread(subject.uri))
      .to eq(IO.binread('spec/fixtures/test_template.docx'))
  end

  describe "#open" do
    before { subject.save! }

    context "without a block" do
      it "returns a io handler" do
        io = subject.open
        expect(io).to behave_like_an_io
        io.close
      end
    end

    context "with a block" do
      it "forwards the io to the block" do
        expect { |b| subject.open(&b) }.to yield_control
        subject.open { |io| expect(io).to behave_like_an_io }
      end
    end
  end
end
