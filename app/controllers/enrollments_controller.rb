class EnrollmentsController < ApplicationController
  def create
    group = Group.find(params[:group_id])
    result = EnrollmentService.new(Current.user, group).enroll

    case result
    when :enrolled
      flash_type = :notice
      message = t(".enrolled")
    when :waitlisted
      position = group.enrollments.find_by(user: Current.user).position

      flash_type = :notice
      message = t(".waitlisted", position: position)
    when :already_enrolled
      flash_type = :alert
      message = t(".already_enrolled")
    else
      flash_type = :alert
      message = t("flash.something_went_wrong")
    end

    group.reload
    respond_with_card(group, flash_type, message)
  end

  def destroy
    enrollment = Current.user.enrollments.find(params[:id])
    group = enrollment.group

    result = EnrollmentService.new(Current.user, group).cancel

    case result
    when :uncancellable
      flash_type = :alert
      message = t(".uncancellable")
    when :cancelled
      flash_type = :notice
      message = t(".cancelled")
    else
      flash_type = :alert
      message = t("flash.something_went_wrong")
    end

    group.reload
    respond_with_card(group, flash_type, message, enrollment: enrollment)
  end

  private

  def respond_with_card(group, flash_type, message, enrollment: nil)
    respond_to do |format|
      format.turbo_stream do
        flash.now[flash_type] = message
        streams = [
          turbo_stream.replace(
            group,
            partial: "schedules/group_card",
            locals: { group: group }
          ),
          turbo_stream.update(
            "flash",
            partial: "layouts/flash"
          )
        ]

        streams << turbo_stream.remove(enrollment) if enrollment

        render turbo_stream: streams
      end

      format.html do
        redirect_to schedule_path, flash: { flash_type => message }, status: :see_other
      end
    end
  end
end
