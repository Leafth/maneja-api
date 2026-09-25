require 'rails_helper'

RSpec.describe "POST /api/v1/auth/login", type: :request do
  let (:password) { "senha123" }
  let (:user) { create(:user, password:, password_confirmation: password) }

  it "authenticates the user and creates a session" do
    expect {
      post "/api/v1/auth/login", params: { user: { email: user.email, password: } }, as: :json
    }.to change(Session, :count).by(1)
    expect(response).to have_http_status(:ok)
  end

  it "returns autentication tokens in response" do
    post "/api/v1/auth/login", params: { user: { email: user.email, password: } }, as: :json
    body = response.parsed_body
    expect(body).to include("access_token" => be_present, "refresh_token" => be_present)
  end

  it "returns unauthorized for invalid password" do
    post "/api/v1/auth/login", params: { user: { email: user.email, password: "invalid-password" } }, as: :json
    expect(response).to have_http_status(:unauthorized)
    expect(response.parsed_body["errors"]["base"]).to be_present
  end

  it "returns unauthorized for invalid email" do
    post "/api/v1/auth/login", params: { user: { email: Faker::Internet.unique.email, password: } }, as: :json
    expect(response).to have_http_status(:unauthorized)
    expect(response.parsed_body["errors"]["base"]).to be_present
  end
end
