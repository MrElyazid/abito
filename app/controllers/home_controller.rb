class HomeController < ApplicationController
  def index
    # Redirect admin users to the admin dashboard
    if current_user&.admin?
      redirect_to admin_root_path
      return # Ensure no further rendering happens
    end

    # Fetch data for the client home page
    @featured_products = Product.includes(:image_attachment => :blob).order(created_at: :desc).limit(3)
  end
end
