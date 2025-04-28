module Admin
  class ProductsController < BaseController
    before_action :set_product, only: [:show, :edit, :update, :destroy, :accept_submission, :reject_submission]

    def index
      @products = Product.includes(:category).order(created_at: :desc)
    end

    def show
      # Show action might not be strictly needed for admin CRUD,
      # but can be useful for previewing.
      # If not needed, remove from routes: resources :products, except: [:show]
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_products_path, notice: 'Product was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @product.update(product_params)
        redirect_to admin_products_path, notice: 'Product was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: 'Product was successfully destroyed.', status: :see_other
    end

    def pending_submissions
      @pending_products = Product.where(status: 'pending').where.not(submitted_by: nil).includes(:submitted_by, :category).order(created_at: :desc)
    end

    def accept_submission
      if @product.update(status: 'accepted')
        redirect_to pending_submissions_admin_products_path, notice: "Product submission accepted."
      else
        redirect_to pending_submissions_admin_products_path, alert: "Failed to accept product submission."
      end
    end

    def reject_submission
      if @product.update(status: 'rejected')
        redirect_to pending_submissions_admin_products_path, notice: "Product submission rejected."
      else
        redirect_to pending_submissions_admin_products_path, alert: "Failed to reject product submission."
      end
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :stock_quantity, :category_id, :image)
    end
  end
end
