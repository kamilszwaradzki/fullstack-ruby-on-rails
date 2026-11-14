require "rails_helper"
RSpec.describe EnrollmentService, type: :service do
  let(:user) { create(:user) }
  let(:group) { create(:group, capacity: 1, starts_at: '18:00') }
  let(:enrollment) { group.enrollments.find_by(user: user) }
  let(:service) { EnrollmentService.new(user, group) }
  describe "#enroll" do
    context "when the group has free spots" do
      it "returns :enrolled" do
        expect(service.enroll).to eq(:enrolled)
      end

      it "creates an active enrollment" do
        service.enroll
        expect(enrollment.status).to eq('active')
      end
    end

    context "when the group is full" do
      before do
        create(:enrollment, group: group, status: :active)
      end

      it "status is waitlisted" do
        service.enroll
        expect(enrollment.status).to eq('waitlisted')
      end

      it "position is one" do
        service.enroll
        expect(enrollment.position).to eq(1)
      end

      it "position is second" do
        create(:enrollment, group: group, status: :waitlisted, position: 1)
        service.enroll
        expect(enrollment.position).to eq(2)
      end
    end

    context "when the user is already enrolled" do
      before do
        create(:enrollment, user: user, group: group, status: :active)
      end

      it "return :already_enrolled" do
        expect(service.enroll).to eq(:already_enrolled)
      end

      it "count is not changed" do
        expect { service.enroll }.not_to change(Enrollment, :count)
      end
    end

    context "when the user cancelled earlier" do
      before do
        create(:enrollment, user: user, group: group, status: :cancelled)
      end

      it "return :enrolled" do
        expect(service.enroll).to eq(:enrolled)
      end

      it "count is not changed" do
        expect { service.enroll }.not_to change(Enrollment, :count)
      end

      it "enrollment is active" do
        service.enroll
        expect(enrollment.status).to eq('active')
      end
    end
  end
end
