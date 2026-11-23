
class Instructor::AttendancesController < InstructorController
  def update
    @group = available_groups.find(params[:group_id])
    lesson = @group.lessons.find(params[:lesson_id])

    if lesson.cancelled?
      redirect_to instructor_group_lesson_path(@group, lesson),
                  alert: t(".cancelled_lesson")
      return
    end

    unless lesson.started?
      redirect_to instructor_group_lesson_path(@group, lesson),
                  alert: t(".not_started")
      return
    end

    user = @group.enrollments.active.find_by!(
      user_id: params[:user_id]
    ).user

    service = AttendanceService.new(user, lesson)

    result = if params[:presence] == "1"
      service.mark_present
    else
      service.mark_absent
    end

    case result
    when :present_without_pass
      redirect_to instructor_group_lesson_path(@group, lesson),
                  alert: t(".present_without_pass")
    else
      redirect_to instructor_group_lesson_path(@group, lesson),
                  notice: t(".success")
    end
  end
end
