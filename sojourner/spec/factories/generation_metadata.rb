FactoryGirl.define do
  factory :generation_metadata do
    transient do
      template_single_version { FactoryGirl.create(:template_single_version) }
    end

    template { template_single_version.template }
    input_data { template_single_version.template_schema.json_stub }
    schema_id { template_single_version.template_schema.id }
    sequence(:document_id) { |n| n.to_s } # Avoid calling doctore id reservation
    sequence(:request_id) { |n| n.to_s }
    document_name "a-document"
    created_by
  end
end
