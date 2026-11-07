FactoryBot.define do
  factory :feeding do
    transient do
      user { association(:user) }
    end

    group { association(:group, user: user) }
    feed { association(:feed, user: user) }

    quantity do
      Faker::Number.decimal(l_digits: 2, r_digits: 2)
    end

    occurred_at { Time.current }
  end
end
