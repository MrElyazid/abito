class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.order(:email)
  end

  def show
    # User details view (optional, can be expanded later)
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "You cannot delete your own admin account."
    else
      # Consider adding dependent: :destroy or :nullify to User model
      # for associated carts/orders if needed.
      @user.destroy
      redirect_to admin_users_path, notice: "User was successfully deleted."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # No user_params needed as we are not creating/updating users via admin for now.
end
