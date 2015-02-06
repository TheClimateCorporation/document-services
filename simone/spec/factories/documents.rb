FactoryGirl.define do
  factory :document do
    name
    created_by

    #testing default
    type "LocalDocument"

    file { File.open('spec/fixtures/empty.pdf') }
    mime_type 'application/pdf'

    #if you want to call out the type explicitly
    trait :local_document do
      type "LocalDocument"
    end

    trait :s3_document do
      type "S3Document"
    end

    # necessary because of the type attr, which needs to be
    # passed to new to instantiate correct subclass
    initialize_with do
      new(attributes)
    end
  end
end
