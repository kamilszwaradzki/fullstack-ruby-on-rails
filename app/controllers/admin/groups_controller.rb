class Admin::GroupsController < AdminController
  before_action :set_group, only: %i[show edit update destroy]

  def index
    @groups = Group.includes(:course, :instructor)
  end

  def show
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to admin_groups_path, notice: "Grupa została dodana"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to admin_groups_path, notice: "Grupa została zmodyfikowana"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @group.destroy
      redirect_to admin_groups_path, notice: "Grupa została usunięta", status: :see_other
    else
      redirect_to admin_groups_path, alert: @group.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private
  def group_params
    params.expect(group: [ :course_id, :instructor_id, :weekday, :starts_at, :duration, :capacity ])
  end

  def set_group
    @group = Group.find(params.expect(:id))
  end
end
