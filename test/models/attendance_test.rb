require "test_helper"

class AttendanceTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert attendances(:one).valid?
  end

  test "belongs to lesson and user" do
    attendance = attendances(:one)

    assert_equal lessons(:one), attendance.lesson
    assert_equal users(:one), attendance.user
  end

  test "requires a lesson" do
    attendance = Attendance.new(user: users(:student))

    assert_not attendance.valid?
    assert_includes attendance.errors[:lesson], "must exist"
  end

  test "requires a user" do
    attendance = Attendance.new(lesson: lessons(:one))

    assert_not attendance.valid?
    assert_includes attendance.errors[:user], "must exist"
  end
end
