class ProductsController < ApplicationController
  def index
    if params[:query].present?
      # Basic case-insensitive search using LIKE
      # Note: For larger datasets, consider using a dedicated search gem (e.g., Ransack, PgSearch)
      # or full-text search capabilities of the database for better performance.
      @products = Product.where("LOWER(name) LIKE ?", "%#{params[:query].downcase}%")
    else
      @products = Product.where(status: ['accepted', nil]).or(Product.where(submitted_by: nil))
    end
  end

  def show
    # Eager load category, comments, and comment users
    @product = Product.includes(:category, comments: :user).find(params[:id])
    # Prepare a new comment object for the form (if user is logged in)
    @comment = Comment.new if user_signed_in?
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    @product.submitted_by = current_user

    if @product.save
      redirect_to products_path, notice: "Product submitted successfully. It will be reviewed by an admin."
    else
      @categories = Category.all
      render :new
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity, :category_id, :image)
  end
end
