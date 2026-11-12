class User < ApplicationRecord
  enum :role, { admin: 0, instructor: 1, participant: 2 }

  has_many :instructed_groups,
    class_name: "Group",
    foreign_key: :instructor_id,
    inverse_of: :instructor
  has_many :enrollments
  has_many :passes
  has_many :attendances
end
