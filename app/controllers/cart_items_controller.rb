class CartItemsController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in
  before_action :set_cart_item, only: [:update, :destroy]

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
  end # End of create action

  def update
    # Decrease quantity by 1
    new_quantity = @cart_item.quantity - 1

    if new_quantity <= 0
      # If quantity drops to 0 or below, remove the item
      product_name = @cart_item.product.name # Get name before destroying
      @cart_item.destroy
      notice = "#{product_name} removed from cart."
    else
      # Otherwise, update the quantity
      if @cart_item.update(quantity: new_quantity)
        notice = "Quantity for #{@cart_item.product.name} updated."
      else
        # Handle update failure (e.g., validation errors, though unlikely here)
        redirect_to cart_path, alert: "Could not update item quantity."
        return # Prevent double redirect
      end
    end
    redirect_to cart_path, notice: notice
  end # End of update action

  def destroy
    product_name = @cart_item.product.name # Get name before destroying
    @cart_item.destroy
    redirect_to cart_path, notice: "#{product_name} removed from cart."
  end # End of destroy action

  private

  def set_cart_item
    @cart = current_cart
    # Ensure the item exists and belongs to the current user's cart
    @cart_item = @cart.cart_items.find_by(id: params[:id])

    if @cart_item.nil?
      redirect_to cart_path, alert: "Cart item not found."
    end
  end # End of set_cart_item
end # End of class
