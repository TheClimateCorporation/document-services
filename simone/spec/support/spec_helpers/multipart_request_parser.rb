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
module SpecHelpers
  module MultipartRequestParser
    extend self

    # Parses multipart requests for Webmock since it doesn't provide a way to
    # verify this type of requests.
    #
    # Example:
    #
    #   stub_request(:post, "example.com")
    #
    #   url = URI.parse("http:://example.com")
    #   req = Net::HTTP::Post::Multipart.new(
    #     url.path,
    #     "file" => UploadIO.new(
    #       StringIO.new("hello world"), "text/plain", "foo.txt"
    #     )
    #   )
    #   Net:HTTP.start(url.host, url.port) do { |http| http.request(req) }
    #
    #   expect(a_request(:post, "example.com).with do |req|
    #     parsed_request = SpecHelpers::MultipartRequestParser.parse(req)
    #     parsed_request['file'][:tempfile].read == "hello world"
    #   end).to have_been_made
    def parse(request)
      StringIO.open(request.body) do |body_stream|
        env = request.headers.transform_keys { |key| key.underscore.upcase }
                             .merge('rack.input' => body_stream)
        Rack::Multipart::Parser.new(env).parse
      end
    end
  end
end
