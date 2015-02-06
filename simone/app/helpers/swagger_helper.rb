module SwaggerHelper
  def api_docs_path
    Rails.env == 'development' ? '/swagger/api-docs.json' : '/simone/swagger/api-docs.json'
  end
end
