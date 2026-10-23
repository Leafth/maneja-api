FactoryBot.define do
  factory :occupation do
    association :group
    association :terrain

    started_at { 1.days.ago }
    ended_at { nil }

    trait :finished do
      started_at { 2.days.ago }
      ended_at { 1.days.ago }
    end
  end
end
