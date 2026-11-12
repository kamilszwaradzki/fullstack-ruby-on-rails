require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert groups(:one).valid?
  end

  test "belongs to course" do
    assert_equal courses(:one), groups(:one).course
  end

  test "belongs to instructor" do
    assert_equal users(:one), groups(:one).instructor
  end

  test "has lessons" do
    assert_includes groups(:one).lessons, lessons(:one)
  end

  test "has enrollments" do
    assert_includes groups(:one).enrollments, enrollments(:one)
  end

  test "requires a course" do
    group = Group.new(instructor: users(:one))

    assert_not group.valid?
    assert_includes group.errors[:course], "must exist"
  end

  test "requires an instructor" do
    group = Group.new(course: courses(:one))

    assert_not group.valid?
    assert_includes group.errors[:instructor], "must exist"
  end
end
