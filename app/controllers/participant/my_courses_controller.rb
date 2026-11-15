class Participant::MyCoursesController < ParticipantController
  def show
    @enrollments = Current.user.enrollments
      .where(status: %i[active waitlisted])
      .order(:status)
      .includes(group: [ :course, :instructor ])
    active_group_ids = @enrollments
      .where(status: :active)
      .select(:group_id)

    @upcoming_lessons = Lesson
      .upcoming
      .where(group_id: active_group_ids)
      .includes(group: :course)
      .order(:starts_at)
      .limit(5)

    @pass = Current.user.current_pass
  end
end
