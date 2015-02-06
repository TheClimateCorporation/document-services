require 'rails_helper'

RSpec.describe StorageLocation, :type => :model do

  # the type-less base class should return (informative) errors
  # on all of the methods the subclasses are required to implement

  it { is_expected.to validate_presence_of :file }
  it { is_expected.to validate_presence_of :type }

  it "will not allow local storage in production" do
    allow(Rails.env).to receive(:production?).and_return(true)
    allow(subject).to receive(:file_saved?)
    subject.type = "LocalStorageLocation"

    expect(subject).not_to be_valid
    expect(subject.errors[:base]).to include("Local storage not allowed in production, " \
        "use S3Location.")
  end

  describe "file_saved?" do
    it "should raise an error" do
      expect {subject.file_saved?}.to raise_error(RuntimeError, "Subclass needs to implement this")
    end
  end

  describe "read_link" do
    it "should raise an error" do
      expect {subject.read_link}.to raise_error(RuntimeError, "Subclass needs to implement this")
    end
  end

  describe "set_uri" do
    it "should raise an error" do
      expect {subject.send(:set_uri)}.to raise_error(RuntimeError, "Subclass needs to implement this")
    end
  end

  describe "put!" do
    it "should raise an error" do
      expect {subject.send(:put!)}.to raise_error(RuntimeError, "Subclass needs to implement this")
    end
  end

  describe "#open" do
    it "raises an error" do
      expect { subject.open }.to raise_error(RuntimeError, "Subclass needs to implement this")
    end
  end
end
