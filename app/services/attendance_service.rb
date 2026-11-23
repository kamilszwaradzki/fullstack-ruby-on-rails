class AttendanceService
  def initialize(user, lesson)
    @user = user
    @lesson = lesson
  end
  def mark_present
    Attendance.transaction do
      attendance = @lesson.attendances.find_or_create_by!(user: @user)
      attendance.lock!
      current_pass = attendance.pass
      presence = attendance.present
      attendance.update!(present: true)

      if current_pass
        return :present
      else
        current_pass = @user.current_pass
        unless current_pass
          return :present_without_pass
        end
      end

      unless presence
        current_pass.lock!
        current_pass.update!(entries_left: current_pass.entries_left - 1)
        attendance.update!(pass: current_pass)
      end

      return :present
    end
  end
  def mark_absent
    Attendance.transaction do
      attendance = @lesson.attendances.find_or_create_by!(user: @user)
      attendance.lock!
      attendance.update!(present: false)
      current_pass = attendance.pass
      if current_pass
        current_pass.lock!
        current_pass.update!(entries_left: current_pass.entries_left + 1)
        attendance.update!(pass: nil)
      end
      return :absent
    end
  end
end
