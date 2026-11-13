FactoryBot.define do
  factory :pass do
    association :user
    entries_total { 8 }
    entries_left { 8 }
    valid_until { 1.month.from_now }
  end
end
