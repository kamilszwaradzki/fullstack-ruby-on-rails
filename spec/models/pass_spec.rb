require "rails_helper"

RSpec.describe Pass, type: :model do
  it "default factory is valid" do
    pass = build(:pass)
    expect(pass).to be_valid
  end

  it { is_expected.to belong_to(:user) }

  describe "#expiring_soon?" do
    around do |example|
      travel_to(Time.zone.local(2026, 11, 15, 12, 0, 0)) do
        example.run
      end
    end

    it "returns true when pass expires within 7 days" do
      pass = build(:pass, valid_until: 5.days.from_now.to_date)

      expect(pass.expiring_soon?).to be true
    end

    it "returns true when pass expires exactly in 7 days" do
      pass = build(:pass, valid_until: 7.days.from_now.to_date)

      expect(pass.expiring_soon?).to be true
    end

    it "returns false when pass expires after 7 days" do
      pass = build(:pass, valid_until: 8.days.from_now.to_date)

      expect(pass.expiring_soon?).to be false
    end

    it "returns false when pass has already expired" do
      pass = build(:pass, valid_until: 1.day.ago.to_date)

      expect(pass.expiring_soon?).to be false
    end
  end

  describe "#low_entries?" do
    it "returns true when one entry remains" do
      pass = build(:pass, entries_left: 1)

      expect(pass.low_entries?).to be(true)
    end

    it "returns false when two entries remain" do
      pass = build(:pass, entries_left: 2)

      expect(pass.low_entries?).to be(false)
    end
  end
end
