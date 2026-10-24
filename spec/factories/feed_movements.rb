FactoryBot.define do
  factory :feed_movement do
    association :feed
    movement_type { :entry }
    quantity { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    value { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    occurred_on { Faker::Date.backward(days: 30) }

    trait :exit do
      movement_type { :exit }
      value { nil }
      reason { Faker::Lorem.sentence }
    end
  end
end
