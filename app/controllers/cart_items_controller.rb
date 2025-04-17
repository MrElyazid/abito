class CartItemsController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in

  def create
    @product = Product.find(params[:product_id])
    @cart = current_cart # Get cart from ApplicationController

    # Find existing cart item or initialize a new one
    @cart_item = @cart.cart_items.find_or_initialize_by(product_id: @product.id)

    # Increment quantity (or set to 1 if new)
    @cart_item.quantity = (@cart_item.quantity || 0) + 1

    if @cart_item.save
      redirect_to cart_path, notice: "#{@product.name} added to cart."
    else
      # Handle potential errors (e.g., validation)
      redirect_to product_path(@product), alert: "Could not add item to cart."
    end
  end
end
