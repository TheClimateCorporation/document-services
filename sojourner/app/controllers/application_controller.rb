class ApplicationController < ActionController::Base

  # CHANGE-ME to your favorite method for grabbing current_user
  def current_user_id
    t = Time.now
    t.strftime("DEMO USER at %H:%M:%S %P %m/%d/%y")
  end
end
