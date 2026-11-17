require "rails_helper"

RSpec.describe "Admin Dashboard", type: :request do
  let(:admin) { create(:user, :admin) }

  before do
    sign_in_as(admin)
  end

  describe "GET /admin/dashboard" do
    it "returns ok for an authenticated admin" do
      get admin_root_path

      expect(response).to have_http_status(:ok)
    end

    it "displays groups with waitlisted enrollments" do
      course = create(:course, name: "Ruby on Rails")
      group = create(:group, course: course)
      create(:enrollment, group: group, status: :waitlisted)

      get admin_root_path

      expect(response).to have_http_status(:ok)
      assert_select "#waitlisted-groups", text: /Ruby on Rails/
    end

    it "does not display groups without waitlisted enrollments" do
      course = create(:course, name: "Python Basics")
      group = create(:group, course: course)
      create(:enrollment, group: group, status: :active)

      get admin_root_path

      expect(response).to have_http_status(:ok)
      assert_select "#waitlisted-groups", text: /Python Basics/, count: 0
    end
  end
end
