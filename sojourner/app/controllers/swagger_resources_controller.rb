class SwaggerResourcesController < ApplicationController
  def show
    content = load_swagger_resource(params[:id])
    render text: content, content_type: 'application/json'
  end

  private

  def load_swagger_resource(resource_id)
    # See `config/initializer/swagger_docs.rb` for constants definition
    resource_path = File.join(SWAGGER_RESOURCES_PATH, "#{resource_id}.json")
    File.read(resource_path).gsub(SWAGGER_URL_PLACEHOLDER, root_url.chomp('/'))
  end
end
