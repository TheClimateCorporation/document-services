require "webmock"

module SpecHelpers
  module Controller
    # RSpec controller specs helpers to make requests as an identified user.
    #
    # Example:
    #
    #   RSpec.describe MyController do
    #     it "sends an identified request" do
    #       request_as "me"
    #       get :index
    #       expect(controller.current_user_id).to eq("me)
    #     end
    #   end
    #
    # See `ApplicationController` for implementation details
    module IdentityHelpers
      # CHANGE-ME?
      def request_as(user_id)
        allow_any_instance_of(self.controller.class)
          .to receive(:current_user_id).and_return(user_id)
      end
    end
  end
end
