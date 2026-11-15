class InstructorController < ApplicationController
  before_action :require_instructor

  private
  def require_instructor
    redirect_to root_path, alert: "Brak dostępu" unless Current.user.instructor? || Current.user.admin?
  end

  protected
  def available_groups
    if Current.user.admin?
      Group.all
    else
      Current.user.instructed_groups
    end
  end
end
