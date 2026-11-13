FactoryBot.define do
  factory :group do
    association :course
    association :instructor, factory: :user, role: :instructor
    weekday { 1 }
    starts_at { 1.week.from_now }
    duration { 60 }
    capacity { 10 }
  end
end
