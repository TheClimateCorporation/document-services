require "rspec/expectations"

# Custom matcher to determine if an object can be used as an IO since no all
# Ruby classes which act like an IO inherit from `IO`, e.g., `StringIO` or
# `Tempfile`
RSpec::Matchers.define :behave_like_an_io do
  match do |obj|
    obj.respond_to?(:gets) && obj.respond_to?(:puts) && obj.respond_to?(:read)
  end
end
