class Group < ApplicationRecord
  validates :starts_at, presence: true
  validates :weekday, presence: true, inclusion: { in: 0..6 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  belongs_to :course
  belongs_to :instructor, class_name: "User", inverse_of: :instructed_groups

  has_many :lessons, dependent: :restrict_with_error
  has_many :enrollments, dependent: :restrict_with_error
end
