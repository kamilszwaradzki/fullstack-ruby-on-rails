require "rails_helper"

RSpec.describe "Instructor Dashboard", type: :request do
  let(:instructor) { create(:user, :instructor) }
  let(:other_instructor) { create(:user, :instructor) }

  let(:course) { create(:course, name: "Ruby on Rails") }
  let(:other_course) { create(:course, name: "Python Basics") }

  let(:group) do
    create(:group, course: course, instructor: instructor)
  end

  let(:other_group) do
    create(:group, course: other_course, instructor: other_instructor)
  end

  before do
    sign_in_as(instructor)
  end

  describe "GET /instructor/dashboard" do
    it "displays the instructor's group and upcoming lesson" do
      create(:lesson, group: group, starts_at: 1.day.from_now)

      get instructor_root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Ruby on Rails")
      expect(response.body).to include("Obecność")
    end

    it "does not display groups belonging to another instructor" do
      create(:lesson, group: other_group, starts_at: 1.day.from_now)

      get instructor_root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("Python Basics")
    end
  end
end
