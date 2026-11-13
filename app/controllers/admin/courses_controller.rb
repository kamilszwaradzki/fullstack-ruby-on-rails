class Admin::CoursesController < AdminController
  before_action :set_course, only: %i[show edit update destroy]

  def index
    @courses = Course.all
  end

  def show
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to admin_courses_path, notice: "Kurs został dodany"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to admin_courses_path, notice: "Kurs został zmodyfikowany"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @course.destroy
      redirect_to admin_courses_path, notice: "Kurs został usunięty", status: :see_other
    else
      redirect_to admin_courses_path, alert: @course.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private
  def course_params
    params.expect(course: [ :name, :description, :level ])
  end

  def set_course
    @course = Course.find(params.expect(:id))
  end
end
