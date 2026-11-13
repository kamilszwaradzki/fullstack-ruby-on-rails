FactoryBot.define do
  factory :attendance do
    association :lesson
    association :user
    present { true }
  end
end
