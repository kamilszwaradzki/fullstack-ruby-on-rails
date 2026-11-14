class EnrollmentService
  def initialize(user, group)
    @user = user
    @group = group
  end

  def enroll
    Enrollment.transaction do
      @group.lock!
      if @group.enrollments.exists?(user: @user, status: [ :active, :waitlisted ])
        return :already_enrolled # "Jesteś już zapisany"
      end

      enrollment = @group.enrollments.find_or_initialize_by(user: @user)

      if @group.full?
        last_position = @group.enrollments.waitlisted.maximum(:position).to_i
        enrollment.update!(status: :waitlisted, position: last_position + 1)
        :waitlisted
      else
        enrollment.update!(status: :active, position: nil)
        :enrolled
      end
    end
  end
end
