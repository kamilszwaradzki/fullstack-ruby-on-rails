class LessonsGeneratorService
  def initialize(group, month)
    @group = group
    @month  = month # Date type
  end
  def call
    lesson_days = (@month.beginning_of_month..@month.end_of_month).select { |d| d >= Date.current && d.wday == @group.weekday }
    created_count = 0
    Lesson.transaction do
      lesson_days.each do |day|
        starts_at = Time.zone.local(day.year, day.month, day.day, @group.starts_at.hour, @group.starts_at.min)
        lesson = @group.lessons.find_or_create_by!(starts_at: starts_at)
        created_count += 1 if lesson.previously_new_record?
      end
    end
    created_count
  end
end
