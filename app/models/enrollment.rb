class Enrollment < ApplicationRecord
  validates :group_id, uniqueness: { scope: :user_id }
  enum :status, { active: 0, waitlisted: 1, cancelled: 2 }

  belongs_to :user
  belongs_to :group
end
