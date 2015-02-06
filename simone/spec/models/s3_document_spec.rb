require 'rails_helper'

RSpec.describe S3Document, :type => :model do
  subject { build(:document, :s3_document) }
  let(:s3_object) { instance_double("AWS::S3::S3Object", write: true) }
  let!(:resv) { IdReservation.create! }

  before do
    allow(subject).to receive(:s3_object) { s3_object }
  end

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
    expected_uri = "#{S3Document::DEFAULT_BUCKET_NAME}/#{S3Document::DEFAULT_PREFIX_BASE}/" \
      "#{subject.document_id}/#{subject.name}#{subject.file_extension}"
    expect(subject.uri).to eq expected_uri
  end

  it "will save the file before creating the record" do
    expect(s3_object).to receive(:write)
    subject.save
  end

  describe "file_saved?" do
    it "tells you if there's something at the uri" do
      allow(s3_object).to receive(:exists?) { true }
      expect(subject.file_saved?).to be(true)
      subject.file_saved?
    end
  end

  describe "file_is_saved" do
    it "checks if the file is saved" do
      expect(s3_object).to receive(:exists?)
      subject.send(:file_is_saved)
    end
  end

  describe "presigned_link is requested" do
    it "returns an AWS::S3::Object when a valid S3Document is requested" do
      expect(s3_object).to receive(:url_for).with(:read)
      subject.read_link
    end
  end
end
