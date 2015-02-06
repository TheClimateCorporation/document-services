FactoryGirl.define do
  factory :template do
    name
    created_by

    #testing default because factory is invalid if type is blank
    type "TemplateSingle"

    #to explictly call out type: single
    trait :single do
      type "TemplateSingle"
    end

    # trait :bundle do
    #   type "TemplateBundle"
    # end

    # ensure that new gets called *with* the attributes,
    # so correctly cast into a subclass
    initialize_with do
      new(attributes)
    end
  end

  sequence(:template_valid_request_params) do
    FactoryGirl
      .attributes_for(:template)
      .except(:created_by)
      .stringify_keys
  end

  sequence(:template_invalid_request_params) do
    keys = FactoryGirl.generate(:template_valid_request_params).keys
    values = Array.new(keys.size, '')
    Hash[keys.zip(values)]
  end
end
