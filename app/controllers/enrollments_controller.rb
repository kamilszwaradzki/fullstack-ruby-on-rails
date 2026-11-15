class EnrollmentsController < ApplicationController
  def create
    group = Group.find(params[:group_id])
    result = EnrollmentService.new(Current.user, group).enroll

    case result
    when :enrolled
      flash_type = :notice
      message = "Zostałeś zapisany"
    when :waitlisted
      position = group.enrollments.find_by(user: Current.user).position

      flash_type = :notice
      message = "Zostałeś dodany do listy oczekujących, pozycja #{position}"
    when :already_enrolled
      flash_type = :alert
      message = "Jesteś już zapisany"
    else
      flash_type = :alert
      message = "Coś poszło nie tak..."
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
      message = "Wypisanie się jest niewykonalne"
    when :cancelled
      flash_type = :notice
      message = "Zostałeś wypisany"
    else
      flash_type = :alert
      message = "Coś poszło nie tak..."
    end

    group.reload
    respond_with_card(group, flash_type, message)
  end

  private

  def respond_with_card(group, flash_type, message)
    respond_to do |format|
      format.turbo_stream do
        flash.now[flash_type] = message

        render turbo_stream: [
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
      end

      format.html do
        redirect_to schedule_path, flash: { flash_type => message }, status: :see_other
      end
    end
  end
end
