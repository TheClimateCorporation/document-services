# The Climate Corporation licenses this file to you under under the Apache
# License, Version 2.0 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.  Unless required by applicable law or agreed
# to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.  See the License for the specific language governing permissions
# and limitations under the License.
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
