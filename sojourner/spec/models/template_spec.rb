require 'rails_helper'

RSpec.describe Template, :type => :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:created_by) }
end
