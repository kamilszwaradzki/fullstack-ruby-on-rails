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

  describe "#cancel" do
    context "when the user is active" do
      before do
        create(:enrollment, user: user, group: group, status: :active)
      end

      it "returns :cancelled" do
        expect(service.cancel).to eq(:cancelled)
      end
    end
    context "when someone is on the waitlist" do
      before do
        create(:enrollment, user: user, group: group, status: :active)
      end
      let!(:waiting) { create(:enrollment, group: group, status: :waitlisted, position: 1) }

      it "one person on waitlist" do
        service.cancel
        waiting.reload
        expect(waiting.status).to eq('active')
        expect(waiting.position).to eq(nil)
      end
    end

    context "when the user is not enrolled" do
      it "returns :uncancellable" do
        expect(service.cancel).to eq(:uncancellable)
      end
    end

    context "when two people are on the waitlist" do
      before do
        create(:enrollment, user: user, group: group, status: :active)
      end
      let!(:first_waiting) { create(:enrollment, group: group, status: :waitlisted, position: 1) }
      let!(:second_waiting) { create(:enrollment, group: group, status: :waitlisted, position: 2) }

      it "two people on waitlist" do
        service.cancel
        first_waiting.reload
        second_waiting.reload
        expect(first_waiting.status).to eq('active')
        expect(first_waiting.position).to eq(nil)
        expect(second_waiting.status).to eq('waitlisted')
        expect(second_waiting.position).to eq(1)
      end
    end
    context "when a waitlisted user cancels" do
      before do
        create(:enrollment, user: user, group: group, status: :waitlisted, position: 1)
      end
      let!(:active_member) { create(:enrollment, group: group, status: :active, position: nil) }
      let!(:next_waiting) { create(:enrollment, group: group, status: :waitlisted, position: 2) }
      it "does not promote anyone and moves the queue up" do
        service.cancel
        active_member.reload
        next_waiting.reload
        expect(enrollment.status).to eq('cancelled')
        expect(active_member.status).to eq('active')
        expect(next_waiting.status).to eq('waitlisted')
        expect(next_waiting.position).to eq(1)
      end
    end
  end
end
