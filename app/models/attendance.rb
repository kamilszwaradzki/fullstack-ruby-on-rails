class Attendance < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  belongs_to :pass, optional: true
end
