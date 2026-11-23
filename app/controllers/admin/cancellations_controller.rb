class Admin::CancellationsController < AdminController
  def create
    @group = Group.find(params[:group_id])
    lesson = @group.lessons.find(params[:lesson_id])
    lesson.update(cancelled_at: Time.current)
    redirect_to admin_group_path(@group), notice: t(".success")
  end
end
