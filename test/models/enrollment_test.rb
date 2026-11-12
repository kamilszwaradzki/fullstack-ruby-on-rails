require "test_helper"

class EnrollmentTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert enrollments(:one).valid?
  end

  test "belongs to user and group" do
    enrollment = enrollments(:one)

    assert_equal users(:one), enrollment.user
    assert_equal groups(:one), enrollment.group
  end

  test "requires a user" do
    enrollment = Enrollment.new(group: groups(:one))

    assert_not enrollment.valid?
    assert_includes enrollment.errors[:user], "must exist"
  end

  test "requires a group" do
    enrollment = Enrollment.new(user: users(:one))

    assert_not enrollment.valid?
    assert_includes enrollment.errors[:group], "must exist"
  end

  test "status enum maps to allowed values" do
    assert enrollments(:one).active?
    assert_equal %w[active waitlisted cancelled], Enrollment.statuses.keys
  end

  test "rejects unknown status" do
    assert_raises(ArgumentError) { Enrollment.new(status: :pending) }
  end
end
