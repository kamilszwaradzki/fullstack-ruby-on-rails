require "rails_helper"

RSpec.describe Enrollment, type: :model do
  it "default factory is valid" do
    enrollment = build(:enrollment)
    expect(enrollment).to be_valid
  end

  it { is_expected.to belong_to(:user) }

  it { is_expected.to belong_to(:group) }

  it { is_expected.to define_enum_for(:status).with_values(active: 0, waitlisted: 1, cancelled: 2) }
end
