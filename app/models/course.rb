class Course < ApplicationRecord
  validates :name, presence: true
  enum :level, { beginner: 0, intermediate: 1, advanced: 2 }

  has_many :groups, dependent: :restrict_with_error
end
