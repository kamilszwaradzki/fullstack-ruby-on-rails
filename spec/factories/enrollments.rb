FactoryBot.define do
  factory :enrollment do
    association :group
    association :user
    status { :active }
    position { 1 }
  end
end
