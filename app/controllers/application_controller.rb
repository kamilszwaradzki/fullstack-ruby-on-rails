class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  def home_path_for(user)
    case user&.role&.to_sym
    when :participant
      participant_my_courses_path
    when :instructor
      instructor_root_path
    when :admin
      admin_root_path
    else
      root_path
    end
  end
end
