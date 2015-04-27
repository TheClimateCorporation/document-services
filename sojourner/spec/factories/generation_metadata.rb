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
