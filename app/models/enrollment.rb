class Enrollment < ApplicationRecord
  enum :status, { active: 0, waitlisted: 1, cancelled: 2 }

  belongs_to :user
  belongs_to :group
end
