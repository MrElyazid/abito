module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    layout 'admin' # Optional: Use a separate layout for admin section

    private

    def require_admin!
      redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
    end
  end
end
