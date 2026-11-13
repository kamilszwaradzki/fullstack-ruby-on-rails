require "rails_helper"
RSpec.describe User, type: :model do
  it "default factory is valid" do
    student = build(:user)
    expect(student).to be_valid
  end
  it "instructor is valid" do
    one = build(:user, role: :instructor)
    expect(one).to be_valid
  end
  it "has instructed groups" do
    one = create(:user, role: :instructor)
    one_group = create(:group, instructor: one)
    expect(one.instructed_groups).to include(one_group)
  end

  it "has enrollments" do
    one = create(:user)
    one_enrollment = create(:enrollment, user: one)
    expect(one.enrollments).to include(one_enrollment)
  end

  it "has passes" do
    one = create(:user)
    one_pass = create(:pass, user: one)
    expect(one.passes).to include(one_pass)
  end

  it "has attendances" do
    one = create(:user)
    one_attendance = create(:attendance, user: one)
    expect(one.attendances).to include(one_attendance)
  end

  it "instructor is instructor" do
    one = build(:user, role: :instructor)
    expect(one).to be_instructor
  end
  it "student is participant" do
    student = build(:user)
    expect(student).to be_participant
  end
  it "role enum maps to allowed values" do
    expect(User.roles.keys).to eq(%w[admin instructor participant])
  end

  it "rejects unknown role" do
    expect { User.new(role: :superhero) }.to raise_error(ArgumentError)
  end
end
