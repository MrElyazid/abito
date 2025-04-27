class ProductsController < ApplicationController
  def index
    if params[:query].present?
      # Basic case-insensitive search using LIKE
      # Note: For larger datasets, consider using a dedicated search gem (e.g., Ransack, PgSearch)
      # or full-text search capabilities of the database for better performance.
      @products = Product.where("LOWER(name) LIKE ?", "%#{params[:query].downcase}%")
    else
      @products = Product.all
    end
  end

  def show
    # Eager load category, comments, and comment users
    @product = Product.includes(:category, comments: :user).find(params[:id])
    # Prepare a new comment object for the form (if user is logged in)
    @comment = Comment.new if user_signed_in?
  end
end
