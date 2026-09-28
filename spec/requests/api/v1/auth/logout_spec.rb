require 'rails_helper'

RSpec.describe "POST /api/v1/auth/logout", type: :request do
  let(:user) { create(:user) }

  it "revokes the session and returns no content" do
    tokens = Auth::CreateSession.call(user:)
    session = user.sessions.last
    delete "/api/v1/auth/logout",
      headers: {
        "Authorization" => "Bearer #{tokens[:access_token]}"
      }
    expect(response).to have_http_status(:no_content)
    expect(session.reload.revoked?).to be(true)
  end

  it "invalidates the access token after logout" do
    tokens = Auth::CreateSession.call(user:)
    delete "/api/v1/auth/logout",
      headers: {
        "Authorization" => "Bearer #{tokens[:access_token]}"
      }
    get "/api/v1/auth/me",
      headers: {
        "Authorization" => "Bearer #{tokens[:access_token]}"
      }
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns unauthorized without an access token" do
    delete "/api/v1/auth/logout"
    expect(response).to have_http_status(:unauthorized)
  end
end
