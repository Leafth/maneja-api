require 'rails_helper'

RSpec.describe "POST /api/v1/auth/me", type: :request do
  let(:user) { create(:user) }

  it "returns the authenticated user" do
    tokens = Auth::CreateSession.call(user:)
    get "/api/v1/auth/me",
      headers: {
        "Authorization" => "Bearer #{tokens[:access_token]}"
      }
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to include("id" => user.id, "name" => user.name, "email" => user.email)
  end

  it "returns unauthorized without an access token" do
    get "/api/v1/auth/me"
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns unauthorized with an invalid access token" do
    get "/api/v1/auth/me",
      headers: {
        "Authorization" => "Bearer invalid-access-token"
      }
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns unauthorized when the session is revoked" do
    tokens = Auth::CreateSession.call(user:)
    user.sessions.last.revoke!
    get "/api/v1/auth/me",
      headers: {
        "Authorization" => "Bearer #{tokens[:access_token]}"
      }
    expect(response).to have_http_status(:unauthorized)
  end
end
