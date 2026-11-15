
require "rails_helper"

RSpec.describe "Instructor::Lessons", type: :request do
  let(:password) { "password" }

  let(:instructor) do
    create(:user, password: password, role: :instructor)
  end

  let(:other_instructor) do
    create(:user, password: password, role: :instructor)
  end

  let(:student) do
    create(:user, password: password, role: :participant)
  end

  let(:group) do
    create(:group, instructor: instructor)
  end

  let(:other_group) do
    create(:group, instructor: other_instructor)
  end

  let(:lesson) { create(:lesson, group: group) }

  describe "GET /instructor/groups/:group_id/lessons/:id" do
    before do
      sign_in_as(instructor)
    end

    it "allows instructor to access their own group" do
      get instructor_group_lesson_path(group, lesson)

      expect(response).to have_http_status(:ok)
    end

    it "returns 404 when accessing another instructor's group" do
      foreign_lesson = create(:lesson, group: other_group)

      get instructor_group_lesson_path(other_group, foreign_lesson)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /instructor" do
    before do
      sign_in_as(student)
    end

    it "redirects participants to root" do
      get instructor_groups_path

      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH attendance" do
    let!(:enrollment) do
      create(:enrollment, :active, group: group, user: student)
    end

    let!(:pass) do
      create(:pass, user: student, entries_left: 5)
    end

    before do
      sign_in_as(instructor)
    end

    it "decrements pass entries when marking student present" do
      expect {
        patch instructor_group_lesson_attendance_path(group, lesson),
              params: {
                user_id: student.id,
                presence: "1"
              }
      }.to change { pass.reload.entries_left }.by(-1)
    end

    it "returns 404 when marking attendance in another instructor's group" do
      foreign_lesson = create(:lesson, group: other_group)

      create(:enrollment, :active, group: other_group, user: student)

      expect {
        patch instructor_group_lesson_attendance_path(other_group, foreign_lesson),
              params: {
                user_id: student.id,
                presence: "1"
              }
      }.not_to change { pass.reload.entries_left }

      expect(response).to have_http_status(:not_found)
    end
  end
end
