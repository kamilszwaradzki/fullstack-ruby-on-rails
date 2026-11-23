class AdminController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    redirect_to root_path, alert: t("flash.access_denied") unless Current.user.admin?
  end
end
