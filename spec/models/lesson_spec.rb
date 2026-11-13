require "rails_helper"

RSpec.describe Lesson, type: :model do
  it "default factory is valid" do
    lesson = build(:lesson)
    expect(lesson).to be_valid
  end

  it { is_expected.to have_many(:attendances) }

  it { is_expected.to belong_to(:group) }
end
