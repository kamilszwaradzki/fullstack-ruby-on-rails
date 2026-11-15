require "rails_helper"

RSpec.describe "Enrollments", type: :request do
  let(:participant) do
    create(:user, role: :participant)
  end

  let(:another_participant) do
    create(:user, role: :participant)
  end

  let(:group) do
    create(:group)
  end

  describe "POST /enrollments" do
    it "responds with turbo stream without removing an enrollment" do
      sign_in_as(participant)

      post enrollments_path,
          params: { group_id: group.id },
          headers: {
            "ACCEPT" => "text/vnd.turbo-stream.html"
          }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream")
      expect(response.body).not_to include(%(action="remove"))
    end

    it "creates an enrollment" do
      sign_in_as(participant)

      expect {
        post enrollments_path,
            params: { group_id: group.id }
      }.to change(Enrollment, :count).by(1)

      expect(response).to redirect_to(schedule_path)
    end
  end

  describe "DELETE /enrollments/:id" do
    it "removes the enrollment card using turbo stream" do
      sign_in_as(participant)

      enrollment = create(:enrollment, user: participant, group: group)

      delete enrollment_path(enrollment),
            headers: {
              "ACCEPT" => "text/vnd.turbo-stream.html"
            }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include(
        %(action="remove" target="enrollment_#{enrollment.id}")
      )
    end

    it "does not allow a participant to withdraw another user's enrollment" do
      sign_in_as(participant)

      other_enrollment = create(
        :enrollment,
        user: another_participant,
        group: group
      )

      expect {
        delete enrollment_path(other_enrollment)
      }.not_to change { other_enrollment.reload.status }

      expect(response).to have_http_status(:not_found)
    end
  end
end
