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
