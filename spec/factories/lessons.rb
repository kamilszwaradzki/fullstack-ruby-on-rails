FactoryBot.define do
  factory :lesson do
    association :group
    starts_at { 1.week.from_now }
  end
end
