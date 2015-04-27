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
