class UiController < ApplicationController
  # protect_with_authentication :ui
  protect_from_forgery with: :exception
end
