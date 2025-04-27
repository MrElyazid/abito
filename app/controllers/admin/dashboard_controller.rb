module Admin
  class DashboardController < BaseController
    def index
      # Add logic later for statistics
      @product_count = Product.count
      @category_count = Category.count
      @user_count = User.count
      @order_count = Order.count # Add order count
    end
  end
end
