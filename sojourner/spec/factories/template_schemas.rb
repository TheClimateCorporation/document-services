FactoryGirl.define do
  factory :template_schema do
    name
    json_schema_properties '{"root": {"type": "object"}}'
    json_stub '{"root": {}}'
    created_by

    trait :immutable do
      after(:create) do |template_schema|
        create_list(:template_single_version, 1, template_schema: template_schema)
        expect(template_schema).to be_immutable # Ensure entry is immutable
      end
    end
  end

  sequence(:template_schema_valid_request_params) do
    FactoryGirl
      .attributes_for(:template_schema)
      .except(:created_by)
      .stringify_keys
  end

  sequence(:template_schema_invalid_request_params) do
    keys = FactoryGirl.generate(:template_schema_valid_request_params).keys
    values = Array.new(keys.size, '')
    Hash[keys.zip(values)]
  end
end
