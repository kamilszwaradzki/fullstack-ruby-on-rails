class Group < ApplicationRecord
  belongs_to :course
  belongs_to :instructor, class_name: "User", inverse_of: :instructed_groups

  has_many :lessons
  has_many :enrollments
end
