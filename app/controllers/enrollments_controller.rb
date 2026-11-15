class EnrollmentsController < ApplicationController
  def create
    group = Group.find(params[:group_id])
    result = EnrollmentService.new(Current.user, group).enroll
    case result
    when :enrolled
      redirect_to schedule_path, notice: "Zostałeś zapisany"
    when :waitlisted
      position = group.enrollments.find_by(user: Current.user).position
      redirect_to schedule_path, notice: "Zostałeś dodany do listy oczekujących, pozycja #{ position }"
    when :already_enrolled
      redirect_to schedule_path, alert: "Jesteś już zapisany"
    else
      redirect_to schedule_path, alert: "Coś poszło nie tak..."
    end
  end
  def destroy
    @enrollment = Current.user.enrollments.find(params[:id])
    result = EnrollmentService.new(Current.user, @enrollment.group).cancel
    case result
    when :uncancellable
      redirect_to schedule_path, alert: "Wypisanie się jest niewykonalne"
    when :cancelled
      redirect_to schedule_path, notice: "Zostałeś wypisany"
    else
      redirect_to schedule_path, alert: "Coś poszło nie tak..."
    end
  end
end
