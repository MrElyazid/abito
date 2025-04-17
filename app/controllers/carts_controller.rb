class CartsController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in

  def show
    @cart = current_cart # Get cart from ApplicationController
    if @cart
      @cart_items = @cart.cart_items.includes(:product) # Eager load products
    else
      # Handle case where cart might not exist (shouldn't happen with ApplicationController setup, but good practice)
      redirect_to root_path, alert: "Could not find your cart."
    end
  end
end
