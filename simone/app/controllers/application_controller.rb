class ApplicationController < ActionController::Base
  # protect_with_authentication :api

  protect_from_forgery with: :null_session

  rescue_from Exception, with: :show_error

  # CHANGE-ME to your favorite method for grabbing current_user
  def current_user_id
    t = Time.now
    t.strftime("DEMO USER at %H:%M:%S %P %m/%d/%y")
  end

  def show_error(error)
    Rails.logger.error error
    render json: { errors: error.message }, status: 500 and return false
  end
end
