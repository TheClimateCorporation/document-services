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
