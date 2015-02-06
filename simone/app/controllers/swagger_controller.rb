class SwaggerController < ApplicationController
  def index
    render layout: false
  end

  def api_docs
    filename = File.join(root_dir, 'api-docs.json')
    content = File.read(filename)
    content.gsub!('simone.test.climatedna', "simone.#{Rails.env}.climatedna")
    render text: content, content_type: 'application/json'
  end

  def doc
    # Only get things that look like version. No paths
    version = params[:version].gsub(/[^v][^\d]/, '')
    doc = "#{params[:doc]}.json"

    filename = File.join(root_dir, version, doc)
    content = File.read(filename)
    content.gsub!('simone.test.climatedna', "simone.#{Rails.env}.climatedna")
    render text: content, content_type: 'application/json'
  end

  private

  def prod_root_dir
    # So prod Rails.root works out to a file in a special jetty dir. So, we go
    # up a level to get to that dir.
    root = File.dirname(Rails.root)
    File.join(root, 'api')
  end

  def root_dir
    Rails.env == 'development' ? File.join(Rails.root, 'public', 'api') : prod_root_dir
  end
end
