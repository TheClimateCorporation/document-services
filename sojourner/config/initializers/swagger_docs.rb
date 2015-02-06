# URL will be dynamically overwritten by the controller.
# See `SwaggerResourcesController`
SWAGGER_URL_PLACEHOLDER = 'swagger.url.placeholder'
SWAGGER_RESOURCES_PATH = Rails.root.join('swagger_resources')

class Swagger::Docs::Config
  # This sets in the api-docs.json file the path to get to the various sub-api
  # json files. This should match the route speficied in the routes file.
  def self.transform_path(path, api_version)
    "#{SWAGGER_URL_PLACEHOLDER}/swagger/resources/#{path}"
  end
end

Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => SWAGGER_RESOURCES_PATH,
    # the URL base path to your API
    :base_path => SWAGGER_URL_PLACEHOLDER,
    # if you want to delete all .json files at each generation
    :clean_directory => true,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "sojourner",
        "description" => "Generate documents from templates",
        "contact" => "caustin@climate.com",
      }
    }
  }
})
