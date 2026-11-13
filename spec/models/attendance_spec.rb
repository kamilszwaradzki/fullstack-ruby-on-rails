require "rails_helper"

RSpec.describe Attendance, type: :model do
  it "default factory is valid" do
    attendance = build(:attendance)
    expect(attendance).to be_valid
  end

  it { is_expected.to belong_to(:user) }

  it { is_expected.to belong_to(:lesson) }
end
