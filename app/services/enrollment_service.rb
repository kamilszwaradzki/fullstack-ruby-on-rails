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

  def cancel
    Enrollment.transaction do
      @group.lock!

      enrollment = @group.enrollments.where(status: [ :active, :waitlisted ]).find_by(user: @user)

      if enrollment.nil?
        return :uncancellable # "Nie da się anulować"
      end

      was_active = enrollment.active?
      enrollment.update!(status: :cancelled, position: nil)
      if was_active
        first_enrollment = @group.enrollments.waitlisted.order(:position).first
        if first_enrollment
          first_enrollment.update!(status: :active, position: nil)
        end
      end
      @group.enrollments.waitlisted.order(:position).each_with_index do |item, index|
        item.update!(position: index + 1)
      end
      :cancelled
    end
  end
end
