class Admin::DashboardController < AdminController
  def index
    @groups = Group.all.includes(:course, :instructor)
    @active_users = Enrollment.active.select(:user_id).distinct.count
    @passes_until_week = Pass.usable.includes(:user).select { |pass| pass.expiring_soon? }
    @groups_full = @groups.select { |group| group.full? }
    @groups_reserved = @groups.joins(:enrollments).where(enrollments: { status: :waitlisted }).distinct
  end
end
