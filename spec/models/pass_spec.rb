require "rails_helper"

RSpec.describe Pass, type: :model do
  it "default factory is valid" do
    pass = build(:pass)
    expect(pass).to be_valid
  end

  it { is_expected.to belong_to(:user) }
end
