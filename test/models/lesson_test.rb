require "test_helper"

class LessonTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert lessons(:one).valid?
  end

  test "belongs to group" do
    assert_equal groups(:one), lessons(:one).group
  end

  test "has attendances" do
    assert_includes lessons(:one).attendances, attendances(:one)
  end

  test "requires a group" do
    lesson = Lesson.new

    assert_not lesson.valid?
    assert_includes lesson.errors[:group], "must exist"
  end
end
