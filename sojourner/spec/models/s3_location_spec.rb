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

RSpec.describe S3Location, :type => :model do

  subject { build(:storage_location, :s3_storage) }
  let(:s3_object) { instance_double("AWS::S3::S3Object", write: true) }

  before do
    allow(subject).to receive(:s3_object) { s3_object }
  end

  describe "file_saved?" do
    it "tells you if there's something at the uri" do
      allow(s3_object).to receive(:exists?) { true }
      expect(subject.file_saved?).to be(true)
      subject.file_saved?
    end
  end

  describe "read_link" do
    it "returns a url to the stored content" do
      expect(s3_object).to receive(:url_for).with(:read)
      subject.read_link
    end
  end

  it "will set the uri" do
    subject.save
    expected_uri = "#{S3Location::DEFAULT_BUCKET_NAME}/#{S3Location::DEFAULT_PREFIX_BASE}/" \
    "#{subject.storable.key_prefix}/#{subject.storable_type}_#{subject.storable_id}.#{subject.storable.file_extension}"
    expect(subject.uri).to eq(expected_uri)
  end

  it "will save the file before creating the record" do
    expect(s3_object).to receive(:write)
    subject.save
  end

  describe "#open" do
    before do
      allow(s3_object).to receive(:url_for) { 'http://fake.im' }
      stub_request(:get, 'http://fake.im')
    end

    context "without a block" do
      it "returns an io object" do
        io = subject.open
        expect(io).to behave_like_an_io
        io.close
      end
    end

    context "with a block" do
      it "passes the io object to the block" do
        expect { |b| subject.open(&b) }.to yield_control
        subject.open { |io| expect(io).to behave_like_an_io }
      end
    end
  end
end
