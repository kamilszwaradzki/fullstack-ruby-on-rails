class Lesson < ApplicationRecord
  belongs_to :group

  has_many :attendances

  scope :active, -> { where(cancelled_at: nil) }
  scope :upcoming, -> { where(starts_at: Time.current..) }

  def cancelled?
    cancelled_at.present?
  end
end
