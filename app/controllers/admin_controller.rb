class AdminController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    redirect_to root_path, alert: "Brak dostępu" unless Current.user.admin?
  end
end
