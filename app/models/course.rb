class Course < ApplicationRecord
  enum :level, { beginner: 0, intermediate: 1, expert: 2 }

  has_many :groups
end
