FactoryGirl.define do
  factory :template_single_version do
    association :template, factory: [:template, :single]
    file { File.open('spec/fixtures/test_template.docx') }
    template_schema
    created_by
  end

  sequence(:template_single_version_valid_request_params) do
    {
      template_schema_id: FactoryGirl.create(:template_schema).id,
      file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/empty.pdf", "application/pdf")
    }
  end

  sequence(:template_single_version_invalid_request_params) do
    {template_schema_id: '', file: ''}
  end
end
