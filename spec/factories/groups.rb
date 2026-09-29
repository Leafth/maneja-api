FactoryBot.define do
  factory :group do
    name { Faker::Creature::Animal.name }
    animal_count { Faker::Number.between(from: 0, to: 100) }
    deleted_at { nil }

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
