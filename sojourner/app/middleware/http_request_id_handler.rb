# Seems some applications actually use a 'X-Http-Request-Id` header to specify
# the request id instead of the Rails standard 'X-Request-Id`. This middleware
# forwards the 'X-Http-Request-Id` value to `X-Request-Id' if not set.
#
# See: http://api.rubyonrails.org/classes/ActionDispatch/RequestId.html
class HttpRequestIdHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    env["HTTP_X_REQUEST_ID"] ||= env["HTTP_X_HTTP_REQUEST_ID"]
    @app.call(env)
  end
end
