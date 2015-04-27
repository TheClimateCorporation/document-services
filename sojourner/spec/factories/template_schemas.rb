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
