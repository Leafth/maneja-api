require 'rails_helper'

RSpec.describe "POST /api/v1/auth/register", type: :request do
  let (:attributes) { attributes_for(:user) }

  it "registers a new user and creates a session" do
    expect {
      post "/api/v1/auth/register", params: { user: attributes }, as: :json
    }.to change(User, :count).by(1)
      .and change(Session, :count).by(1)
    expect(response).to have_http_status(:created)
  end

  it "returns the user and authentication tokens in response" do
    post "/api/v1/auth/register", params: { user: attributes }, as: :json
    body = response.parsed_body
    expect(body["user"]).to include(
      "name" => attributes[:name],
      "email" => attributes[:email]
    )
    expect(body["user"]["id"]).to be_present
    expect(body).to include("access_token" => be_present, "refresh_token" => be_present)
  end

  it "does not expose sensitive information in the response" do
    post "/api/v1/auth/register", params: { user: attributes }, as: :json
    body = response.parsed_body["user"]
    expect(body).not_to have_key("encrypted_password")
    expect(body).not_to have_key("reset_password_token")
  end

  it "returns validation errors for invalid user attributes" do
    post "/api/v1/auth/register", params: { user: attributes.merge(email: nil) }, as: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.parsed_body["errors"]["email"]).to be_present
  end
end
