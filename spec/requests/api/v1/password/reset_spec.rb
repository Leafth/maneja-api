require 'rails_helper'

RSpec.describe "POST /api/v1/password/reset", type: :request do
  let(:user) { create(:user) }
  let(:new_password) { "novaSenha123" }

  let(:reset_token) do
    code = user.send_reset_password_instructions
    Auth::VerifyPasswordResetCode.call(code:)
  end

  it "resets the user password" do
    patch "/api/v1/password/reset", params: { reset_token:, password: new_password, password_confirmation: new_password }, as: :json
    expect(response).to have_http_status(:no_content)
    expect(user.reload.valid_password?(new_password)).to be(true)
  end

  it "revokes active sessions" do
    session = create(:session, user:)
    patch "/api/v1/password/reset", params: { reset_token:, password: new_password, password_confirmation: new_password }, as: :json
    expect(response).to have_http_status(:no_content)
    expect(session.reload.revoked?).to be(true)
  end

  it "returns unauthorized for invalid reset token" do
    patch "/api/v1/password/reset", params: { reset_token: "invalid-token", password: new_password, password_confirmation: new_password }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns validation errors for an invalid password" do
    patch "/api/v1/password/reset", params: { reset_token:, password: "short", password_confirmation: "short" }, as: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.parsed_body["errors"]["password"]).to be_present
  end

  it "does not allow the reset token to be reused" do
    patch "/api/v1/password/reset", params: { reset_token:, password: new_password, password_confirmation: new_password }, as: :json
    expect(response).to have_http_status(:no_content)
    patch "/api/v1/password/reset", params: { reset_token:, password: "anotherPassword123", password_confirmation: "anotherPassword123" }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
