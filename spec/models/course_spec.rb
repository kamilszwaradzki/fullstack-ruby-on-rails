require "rails_helper"

RSpec.describe Course, type: :model do
  it "default factory is valid" do
    course = build(:course)
    expect(course).to be_valid
  end

  it { is_expected.to have_many(:groups) }

  it { is_expected.to define_enum_for(:level).with_values(beginner: 0, intermediate: 1, advanced: 2) }
end
