class Instructor::GroupsController < InstructorController
  before_action :set_group, only: %i[show]

  def index
    @groups = available_groups.includes(:course, :instructor)
  end

  def show
  end

  private

  def set_group
    @group = available_groups.find(params.expect(:id))
  end
end
