
class Instructor::AttendancesController < InstructorController
  def update
    @group = available_groups.find(params[:group_id])
    lesson = @group.lessons.find(params[:lesson_id])

    if lesson.cancelled?
      redirect_to instructor_group_lesson_path(@group, lesson),
                  alert: "Nie można zmienić obecności na odwołanej lekcji."
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
                  alert: "Uczestnik został oznaczony jako obecny, ale nie posiada ważnego karnetu."
    else
      redirect_to instructor_group_lesson_path(@group, lesson),
                  notice: "Zaktualizowano obecność uczestnika."
    end
  end
end
