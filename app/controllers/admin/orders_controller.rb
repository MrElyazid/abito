class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show]

  def index
    # Eager load associated user and order items/products for efficiency
    @orders = Order.includes(:user, order_items: :product).order(created_at: :desc)
  end

  def show
    # @order is set by the before_action
    # Eager loading is done here as well for the show view
    @order = Order.includes(order_items: :product).find(params[:id])
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  # No params needed as we are only viewing orders
end
