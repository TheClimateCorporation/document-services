FactoryGirl.define do
  sequence(:name) { |n| "Name #{n}" }
  sequence(:user_id, aliases: [:created_by]) { |n| n.to_s }
end
