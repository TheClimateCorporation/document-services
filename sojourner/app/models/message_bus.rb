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
class MessageBus

  STUB_PUBLISHING = DotProperties.fetch('message_bus.stub_publishing') { 'true' }

  def self.publish(routing_key, exchange, message)
    return true if STUB_PUBLISHING == 'true'

    begin
      connection.post('messages', {
        routing_key: routing_key,
        exchange: exchange,
        data: message.to_json
      })
    rescue ArgumentError, Faraday::Error => err
      # TODO: implement handling of failed publish methods
    end
  end

  private

  def self.connection
    @connection  ||= Faraday.new(:url => MESSAGE_BUS_CONFIG["uri"]) do |faraday|
      faraday.request  :json
      faraday.response :raise_error
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

end
