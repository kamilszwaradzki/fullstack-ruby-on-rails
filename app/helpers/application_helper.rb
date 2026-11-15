module ApplicationHelper
  def home_path_for(user)
    case user&.role&.to_sym
    when :participant
      participant_my_courses_path
    when :instructor
      instructor_groups_path
    when :admin
      admin_root_path
    else
      root_path
    end
  end
end
