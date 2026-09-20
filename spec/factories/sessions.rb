FactoryBot.define do
  factory :session do
    user { nil }
    refresh_token_digest { "MyString" }
    expires_at { "2026-09-20 11:50:00" }
    revoked_at { "2026-09-20 11:50:00" }
  end
end
