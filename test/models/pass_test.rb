require "test_helper"

class PassTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert passes(:one).valid?
  end

  test "belongs to user" do
    assert_equal users(:one), passes(:one).user
  end

  test "requires a user" do
    pass = Pass.new

    assert_not pass.valid?
    assert_includes pass.errors[:user], "must exist"
  end
end
