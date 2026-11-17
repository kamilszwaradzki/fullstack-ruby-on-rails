class Instructor::DashboardController < InstructorController
  def index
    @groups = available_groups
  end
end
