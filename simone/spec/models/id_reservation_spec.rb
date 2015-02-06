require 'rails_helper'

RSpec.describe IdReservation, :type => :model do

  let!(:r) { IdReservation.create! }

  it 'generates a uuid' do
    expect(r.document_id).to_not be_nil
  end

  it 'ensures the uuid is uniqe' do
    r2 = IdReservation.new(document_id: r.document_id)
    expect(r2).to_not be_valid
  end

  it 'is enabled by default' do
    expect(r.enabled).to eq true
  end

  it 'does not return non-enabled reservations by default' do
    r = IdReservation.create!(enabled: false)
    expect(IdReservation.last).to_not eq r
  end

  describe "#disaable" do
    it "sets enabled to false" do
      r.disable
      expect(r.enabled).to eq false
    end
  end
end
