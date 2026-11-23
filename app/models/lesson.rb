class Lesson < ApplicationRecord
  belongs_to :group

  has_many :attendances

  scope :active, -> { where(cancelled_at: nil) }
  scope :upcoming, -> { where(starts_at: Time.current..) }
  scope :from_today, -> { where(starts_at: Time.current.beginning_of_day..) }

  def cancelled?
    cancelled_at.present?
  end

  def started?
    starts_at <= Time.current
  end
end
