class Admin::LessonGenerationsController < AdminController
  def create
    @group = Group.find(params[:group_id])
    @date = Date.current.next_month
    service = LessonsGeneratorService.new(@group, @date)
    total_lessons = service.call
    redirect_to admin_group_path(@group), notice: "Utworzono #{total_lessons} lekcje"
  end
end
