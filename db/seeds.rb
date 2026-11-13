# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.find_or_create_by!(email_address: 'admin@example.com') do |user|
  user.name = 'admin'
  user.password = 'Admin123!'
  user.role = :admin
end
User.find_or_create_by!(email_address: 'instructor@example.com') do |user|
  user.name = 'instructor'
  user.password = 'Instructor456!'
  user.role = :instructor
end
User.find_or_create_by!(email_address: 'student@example.com') do |user|
  user.name = 'student'
  user.password = 'Student789!'
  user.role = :participant
end
