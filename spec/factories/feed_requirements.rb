FactoryBot.define do
  factory :feed_requirement do
    transient do
      user { association :user }
    end

    group { association :group, user: user }
    feed { association :feed, user: user }

    quantity_per_animal_kg do
      Faker::Number.decimal(l_digits: 2, r_digits: 2)
    end
  end
end
