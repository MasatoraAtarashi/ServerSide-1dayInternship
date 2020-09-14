FactoryBot.define do
  factory :card do
    sequence(:person_id) { 1 }
    sequence(:name) { |n| "TEST_NAME#{n}"}
    sequence(:email) { |n| "TEST#{n}@example.com"}
  end
end