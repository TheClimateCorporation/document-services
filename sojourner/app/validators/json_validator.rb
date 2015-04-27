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
class JsonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # `value` to validate can be customized by passing the `value` options,
    # currently supporting a record method as a `Symbol`. Add other cases if
    # necessary (eg. lambda, string interpolation, etc)
    value = record.send(options[:value]) if options[:value]

    %w(format schema data).each do |subject|
      send("validate_each_#{subject}", record, attribute, value)
      break if record.errors[attribute].present?
    end
  end

  private

  def validate_each_format(record, attribute, value)
    begin
      MultiJson.load(value)
    rescue MultiJson::ParseError => e
      record.errors[attribute] << e.cause.to_s
    end
  end

  def validator_options
    options.except(:as_schema, :schema)
  end

  def validate_each_schema(record, attribute, value)
    return nil unless options[:as_schema]

    errors = JSON::Validator.fully_validate_schema(value, validator_options)
    record.errors[attribute].concat(errors)
  end

  def validate_each_data(record, attribute, value)
    return nil unless options[:schema]

    schema = options[:schema].respond_to?(:call) ?
      options[:schema].call(record) : options[:schema]

    errors = JSON::Validator.fully_validate(schema, value, validator_options)
    record.errors[attribute].concat(errors)
  end
end
