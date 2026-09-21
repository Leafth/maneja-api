FactoryBot.define do
  factory :session do
    association :user

    refresh_token_digest { SecureRandom.hex(64) }
    expires_at { 30.days.from_now }
    revoked_at { nil }

    trait :expired do
      expires_at { 1.minute.ago }
    end

    trait :revoked do
      revoked_at { Time.current }
    end
  end
end
