require "rails_helper"

RSpec.describe AttendanceService, type: :service do
  let(:user) { create(:user) }
  let(:lesson) { create(:lesson) }
  let(:service) { AttendanceService.new(user, lesson) }

  describe "#mark_present" do
    context "when user has a pass" do
      let!(:pass) { create(:pass, user: user, entries_left: 5) }

      it "decrements entries_left" do
        expect {
          service.mark_present
        }.to change { pass.reload.entries_left }.by(-1)
      end

      it "assigns pass to attendance" do
        service.mark_present

        attendance = lesson.attendances.find_by(user: user)

        expect(attendance.pass).to eq(pass)
      end

      it "returns :present" do
        expect(service.mark_present).to eq(:present)
      end

      context "when user was absent" do
        before do
          service.mark_absent
        end

        it "decrements entries_left again" do
          expect {
            service.mark_present
          }.to change { pass.reload.entries_left }.by(-1)
        end

        it "returns :present" do
          expect(service.mark_present).to eq(:present)
        end
      end
    end

    context "when user is already present" do
      let!(:pass) { create(:pass, user: user, entries_left: 5) }

      before do
        service.mark_present
      end

      it "does not change entries_left" do
        expect {
          service.mark_present
        }.not_to change { pass.reload.entries_left }
      end
    end

    context "when user has no pass" do
      it "returns :present_without_pass" do
        expect(service.mark_present).to eq(:present_without_pass)
      end

      it "creates attendance without pass" do
        service.mark_present

        attendance = lesson.attendances.find_by(user: user)

        expect(attendance).to be_present
        expect(attendance.present).to be true
        expect(attendance.pass).to be_nil
      end
    end
  end

  describe "#mark_absent" do
    context "when user was present" do
      let!(:pass) { create(:pass, user: user, entries_left: 5) }

      before do
        service.mark_present
      end

      it "increments entries_left" do
        expect {
          service.mark_absent
        }.to change { pass.reload.entries_left }.by(1)
      end

      it "clears pass from attendance" do
        service.mark_absent

        attendance = lesson.attendances.find_by(user: user)

        expect(attendance.pass).to be_nil
      end

      it "returns :absent" do
        expect(service.mark_absent).to eq(:absent)
      end

      context "when user was present again after being absent" do
        before do
          service.mark_absent
          service.mark_present
        end

        it "increments entries_left when marked absent again" do
          expect {
            service.mark_absent
          }.to change { pass.reload.entries_left }.by(1)
        end

        it "returns :absent" do
          expect(service.mark_absent).to eq(:absent)
        end
      end
    end

    context "when user is already absent" do
      let!(:pass) { create(:pass, user: user, entries_left: 5) }

      before do
        service.mark_absent
      end

      it "does not change entries_left" do
        expect {
          service.mark_absent
        }.not_to change { pass.reload.entries_left }
      end
    end
  end
end
