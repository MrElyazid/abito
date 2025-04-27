class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @cart = current_user.cart
    if @cart.nil? || @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    # Start a transaction to ensure atomicity
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build(status: 'pending') # Initial status

      total_price = 0
      @cart.cart_items.includes(:product).each do |cart_item|
        product = cart_item.product
        # Basic check if product still exists and has stock (can be enhanced)
        if product.nil? || product.stock_quantity < cart_item.quantity
          # Redirect or render with error, rolling back the transaction
          redirect_to cart_path, alert: "Sorry, '#{product&.name || 'Item'}' is out of stock or unavailable."
          raise ActiveRecord::Rollback # Important: Rollback transaction
        end

        order_item = @order.order_items.build(
          product: product,
          quantity: cart_item.quantity,
          price: product.price # Store price at time of order
        )
        total_price += order_item.quantity * order_item.price

        # Optional: Decrement product stock (consider race conditions in real app)
        # product.decrement!(:stock_quantity, cart_item.quantity)
      end

      @order.total_price = total_price
      @order.save! # Use save! to raise exception on failure within transaction

      # Clear the cart after successful order creation
      @cart.cart_items.destroy_all
      # Or destroy the cart itself: @cart.destroy

      # Redirect to a confirmation/thank you page (or root for now)
      redirect_to root_path, notice: "Order placed successfully! Your order ID is ##{@order.id}."
    end
  rescue ActiveRecord::RecordInvalid => e
    # Handle validation errors if save! fails
    redirect_to cart_path, alert: "There was an error placing your order: #{e.message}"
  rescue ActiveRecord::Rollback
    # Transaction was rolled back (e.g., due to stock issue), alert was already set.
    # No further action needed here as redirect happened before rollback.
  end

  def index
    # Fetch orders for the current user, newest first
    @orders = current_user.orders.includes(order_items: :product).order(created_at: :desc)
  end

  def show
    # Fetch a specific order for the current user
    @order = current_user.orders.includes(order_items: :product).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "Order not found."
  end
end
