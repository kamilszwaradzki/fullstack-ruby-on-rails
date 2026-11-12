require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "fixtures are valid" do
    assert users(:one).valid?
    assert users(:student).valid?
  end

  test "has instructed groups" do
    assert_includes users(:one).instructed_groups, groups(:one)
  end

  test "has enrollments" do
    assert_includes users(:one).enrollments, enrollments(:one)
  end

  test "has passes" do
    assert_includes users(:one).passes, passes(:one)
  end

  test "has attendances" do
    assert_includes users(:one).attendances, attendances(:one)
  end

  test "role enum maps to allowed values" do
    assert users(:one).instructor?
    assert users(:student).participant?
    assert_equal %w[admin instructor participant], User.roles.keys
  end

  test "rejects unknown role" do
    assert_raises(ArgumentError) { User.new(role: :superhero) }
  end
end
