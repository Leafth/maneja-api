FactoryBot.define do
  factory :terrain do
    name { Faker::Address.community }
    rest_days { Faker::Number.between(from: 0, to: 60) }
    status { :available }
    deleted_at { nil }

    trait :occupied do
      status { :occupied }
    end

    trait :resting do
      status { :resting }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
