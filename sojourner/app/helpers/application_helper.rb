module ApplicationHelper
  def beautify_json(json_string)
    JSON.pretty_generate(MultiJson.load(json_string))
  end
end
