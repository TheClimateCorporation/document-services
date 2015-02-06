FactoryGirl.define do
  factory :storage_location do

    #testing defaults
    type "NullLocation"
    file { File.open('spec/fixtures/empty.pdf') }
    association :storable, factory: :template_single_version, strategy: :build_stubbed

    #if you actaully want to use a file for a test?
    trait :local_storage do
      type "LocalStorageLocation"
    end

    trait :s3_storage do
      type "S3Location"
    end

    #TODO:
    # trait :gm_storable do
    #   storable { build_stubbed(:generation_metadata) }
    # end

    # necessary because of the type attr, which needs to be
    # passed to new to instantiate correct subclass
    initialize_with do
      new(attributes)
    end
  end
end
