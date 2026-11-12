require "test_helper"

class CourseTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert courses(:one).valid?
  end

  test "has groups" do
    assert_includes courses(:one).groups, groups(:one)
  end
end
