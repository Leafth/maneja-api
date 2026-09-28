require 'rails_helper'

RSpec.describe "POST /api/v1/auth/refresh", type: :request do
  let(:user) { create(:user) }

  it "renews the access token using a valid refresh token" do
    tokens = Auth::CreateSession.call(user:)
    post "/api/v1/auth/refresh", params: { refresh_token: tokens[:refresh_token] }, as: :json
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body).to include("access_token" => be_present, "refresh_token" => be_present)
    expect(body["refresh_token"]).not_to eq(tokens[:refresh_token])
  end

  it "keeps the same session" do
    tokens = Auth::CreateSession.call(user:)
    expect {
      post "/api/v1/auth/refresh", params: { refresh_token: tokens[:refresh_token] }, as: :json
    }.not_to change(Session, :count)
  end

  it "invalidates the previous refresh token" do
    tokens = Auth::CreateSession.call(user:)
    post "/api/v1/auth/refresh", params: { refresh_token: tokens[:refresh_token] }, as: :json
    post "/api/v1/auth/refresh", params: { refresh_token: tokens[:refresh_token] }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns unauthorized for invalid refresh token" do
    post "/api/v1/auth/refresh", params: { refresh_token: "invalid-refresh-token" }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
