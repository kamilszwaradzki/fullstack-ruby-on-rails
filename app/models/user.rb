class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  enum :role, { admin: 0, instructor: 1, participant: 2 }

  has_many :instructed_groups,
    class_name: "Group",
    foreign_key: :instructor_id,
    inverse_of: :instructor
  has_many :enrollments
  has_many :passes
  has_many :attendances

  def enrollment_for(group)
    enrollments.where(status: [ :active, :waitlisted ]).find_by(group: group)
  end
  def current_pass
    passes.usable.order(:valid_until).first
  end
end
