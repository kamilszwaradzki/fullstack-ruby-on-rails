require "rails_helper"

RSpec.describe User, type: :model do
  it "default factory is valid" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "instructor is valid" do
    instructor = build(:user, role: :instructor)
    expect(instructor).to be_valid
  end

  it { is_expected.to have_many(:instructed_groups).class_name("Group").with_foreign_key(:instructor_id) }

  it { is_expected.to have_many(:enrollments) }

  it { is_expected.to have_many(:passes) }

  it { is_expected.to have_many(:attendances) }

  it { is_expected.to define_enum_for(:role).with_values(admin: 0, instructor: 1, participant: 2) }

  it "rejects unknown role" do
    expect { User.new(role: :superhero) }.to raise_error(ArgumentError)
  end
end
