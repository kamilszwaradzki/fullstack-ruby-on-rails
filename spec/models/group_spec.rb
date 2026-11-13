require "rails_helper"

RSpec.describe Group, type: :model do
  it "default factory is valid" do
    group = build(:group)
    expect(group).to be_valid
  end

  it { is_expected.to belong_to(:course) }

  it { is_expected.to belong_to(:instructor).class_name("User") }

  it { is_expected.to have_many(:lessons) }

  it { is_expected.to have_many(:enrollments) }
end
