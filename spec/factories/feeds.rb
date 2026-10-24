FactoryBot.define do
  factory :feed do
    association :user
    name { Faker::Food.ingredient }
    stock_quantity { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    deleted_at { nil }

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
