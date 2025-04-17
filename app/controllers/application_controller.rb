class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_cart
  helper_method :current_cart # Make current_cart available in views

  private

  def set_current_cart
    if user_signed_in?
      # Find the user's cart or create one if it doesn't exist
      @current_cart = current_user.cart || current_user.create_cart
    end
  end

  # Expose @current_cart through a helper method
  def current_cart
    @current_cart
  end
end
