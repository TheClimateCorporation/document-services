module SpecHelpers
  module Request
    # RSpec request specs helpers to make requests as an identified user.
    #
    # Example:
    #
    #   RSpec.describe "My request" do
    #     it "sends an identified request" do
    #       request_as "me"
    #       get :index
    #       expect(@controller.current_user_id).to eq("me)
    #     end
    #   end
    #
    # See `ApplicationController` for implementation details
    module IdentityHelpers
      extend ActiveSupport::Concern

      included do
        after { @user_id = nil }
      end

      def request_as(user_id)
        @user_id = user_id
      end

      # %w(get post patch put head delete).each do |method|
      #   define_method(method) do |path, parameters = nil, headers_or_env = {}|
      #     CHANGE-ME to stuff that's useful
      #   end
      # end
    end
  end
end
