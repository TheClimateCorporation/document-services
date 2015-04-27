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
  # the type-less base class should return (informative) errors
  # on all of the methods the subclasses are required to implement

  it { is_expected.to validate_presence_of :file }
  it { is_expected.to validate_presence_of :type }
  it { is_expected.to validate_presence_of :name }

  it "will not allow local storage in production" do
    allow(Rails.env).to receive(:production?).and_return(true)
    allow(subject).to receive(:file_saved?)
    subject.type = "LocalDocument"

    expect(subject).not_to be_valid
    expect(subject.errors[:base]).to include("Local storage not allowed in production, " \
        "use S3Document.")
  end

  it "checks for a reservation" do
    expect(subject).to receive(:check_reservation)
    subject.save
  end

  describe "check_reservation" do
    context "when no document_id or reservation is specified" do
      it "creates a reservation" do
        expect(IdReservation).to receive(:create)
        subject.save
      end
    end

    context "when a document_id is specified on create" do
      let(:resv) { IdReservation.create }

      it "adds an error if the document_id doesn't refer to an existing reservation" do
        doc = Document.new(document_id: "seven")
        doc.valid?
        expect(doc.errors[:document_id]).to include("was specified but does not " \
          "refer to a valid IdReservation")
      end

      it "adds an error if the referenced document_id has already been used" do
        create(:document, reservation: resv)
        doc2 = Document.new(document_id: resv.document_id)
        doc2.valid?
        expect(doc2.errors[:document_id]).to include("refers to an IdReservation " \
          "which has already been used")
      end

      it "does not have errors if a valid reservation is supplied" do
        doc3 = doc2 = Document.new(document_id: resv.document_id)
        doc3.valid?
        expect(doc3.errors[:document_id]).to be_empty
      end
    end
  end

  describe "file_saved?" do
    it "should raise an error" do
      expect {subject.file_saved?}.to raise_error(RuntimeError, "Subclass needs to implement this")
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

  describe "file_is_saved" do
    context "when file_saved? errors (as in the base class)" do
      it "should raise an error" do
        expect(subject).to receive(:file_saved?).and_call_original
        expect {subject.send(:file_is_saved)}.to raise_error(RuntimeError, "Subclass needs to implement this")
      end
    end

    context "when file_saved is implemented (as in each subclass)" do
      it "adds an error if the nothing exists at the uri" do
        allow(subject).to receive(:file_saved?).and_return(false)
        subject.send(:file_is_saved)
        expect(subject.errors[:file]).to include("is not saved!")
      end

      it "does not add an error if the file is properly saved" do
        allow(subject).to receive(:file_saved?).and_return(true)
        subject.send(:file_is_saved)
        expect(subject.errors[:file]).to be_empty
      end
    end
  end

  describe "read_link" do
    it "should raise an error" do
      expect {subject.read_link}.to raise_error(RuntimeError, "Subclass needs to implement this")
    end
  end

end
