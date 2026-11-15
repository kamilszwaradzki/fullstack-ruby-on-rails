require 'rails_helper'

RSpec.describe "Participant::MyCourses", type: :request do
  let(:password) { "password" }

  let(:participant) do
    create(:user, password: password, role: :participant)
  end

  let(:instructor) do
    create(:user, role: :instructor)
  end

  let(:course) do
    create(:course, name: "Ruby on Rails")
  end

  let(:group) do
    create(:group, course: course, instructor: instructor)
  end

  let!(:enrollment) do
    create(:enrollment, :active, user: participant, group: group)
  end

  describe "GET /participant/my_courses" do
    context "when user is not authenticated" do
      it "redirects to login" do
        get participant_my_courses_path

        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when participant is authenticated" do
      before do
        sign_in_as(participant)
      end

      it "displays their enrolled groups" do
        get participant_my_courses_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Ruby on Rails")
      end

      it "does not display other participants' enrollments" do
        other_participant = create(:user, role: :participant)
        other_course = create(:course, name: "Python Programming")
        other_group = create(
          :group,
          course: other_course,
          instructor: instructor
        )

        create(
          :enrollment,
          :active,
          user: other_participant,
          group: other_group
        )

        get participant_my_courses_path

        expect(response.body).to include("Ruby on Rails")
        expect(response.body).not_to include("Python Programming")
      end

      it "displays current pass entries" do
        create(
          :pass,
          user: participant,
          entries_left: 3,
          entries_total: 8,
          valid_until: 30.days.from_now.to_date
        )

        get participant_my_courses_path

        expect(response.body).to include("3/8")
      end
    end
  end
end
