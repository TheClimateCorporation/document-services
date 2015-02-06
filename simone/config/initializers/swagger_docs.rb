class Swagger::Docs::Config
  # This sets in the api-docs.json file the path to get to the various sub-api
  # json files. In our case that is only orders.
  def self.transform_path(path, api_version)
    "swagger/#{path}"
  end
end

Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => "public/api",
    # the URL base path to your API
    # :base_path => '/', #by default
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "simone",
        "description" => "Store and serve documents",
        "contact" => "caustin@climate.com",
      }
    }
  }
})
