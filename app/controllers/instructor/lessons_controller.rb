class Instructor::LessonsController < InstructorController
  before_action :set_lesson, only: %i[show]

  def show
    @enrollments = @group.enrollments.active.includes(:user)
    @attendances = @lesson.attendances.index_by(&:user_id)
  end

  private
  def set_lesson
    @group = available_groups.find(params[:group_id])
    @lesson = @group.lessons.find(params.expect(:id))
  end
end
