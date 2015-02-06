require 'rails_helper'

RSpec.describe NullLocation, :type => :model do
  #null is the default type for the storage_location
  #factory in test env. it's purpose is to not break tests.

  describe "file_saved?" do
    it "should not raise an error" do
      expect {subject.file_saved?}.not_to raise_error
    end
  end

  describe "put!" do
    it "should not raise an error" do
      expect {subject.send(:put!)}.not_to raise_error
    end
  end

  describe "open" do
    it "does not raise an error" do
      expect { subject.open }.not_to raise_error
    end
  end
end
