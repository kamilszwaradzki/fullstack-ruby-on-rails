require "rails_helper"
RSpec.describe LessonsGeneratorService, type: :service do
  before do
    travel_to Date.new(2026, 11, 14)
  end

  let(:group) { create(:group, weekday: 3, starts_at: '18:00') }
  let(:service) { LessonsGeneratorService.new(group, Date.new(2026, 12, 1)) }

  it "creates a lesson for every Wednesday in the month" do
    expect { service.call }.to change(Lesson, :count).by(5)
  end

  it "sets the lesson start time from the group schedule" do
    service.call
    first_lesson = group.lessons.order(:starts_at).first
    expect(first_lesson.starts_at).to eq(Time.zone.local(2026, 12, 2, 18, 0))
  end

  it "does not create duplicates when called twice" do
    service.call
    expect { service.call }.not_to change(Lesson, :count)
  end
end
