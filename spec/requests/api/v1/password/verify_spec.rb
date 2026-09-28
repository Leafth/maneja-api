require 'rails_helper'

RSpec.describe "POST /api/v1/password/verify", type: :request do
  let(:user) { create(:user) }

  it "returns a temporary token for a valid reset code" do
    code = user.send_reset_password_instructions
    post "/api/v1/password/verify", params: { code: code }, as: :json
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["reset_token"]).to be_present
  end

  it "returns a reset token associated with the user" do
    code = user.send_reset_password_instructions
    post "/api/v1/password/verify", params: { code: code }, as: :json
    reset_token = response.parsed_body["reset_token"]
    recovered_user = User.find_by_token_for(:password_reset_verification, reset_token)
    expect(recovered_user).to eq(user)
  end

  it "returns unauthorized for an invalid reset code" do
    post "/api/v1/password/verify", params: { code: "invalid-code" }, as: :json
    expect(response).to have_http_status(:unauthorized)
    expect(response.parsed_body["errors"]["base"]).to be_present
  end

  it "returns unauthorized for an expired reset code" do
    code = user.send_reset_password_instructions
    user.update_column(:reset_password_sent_at, (Devise.reset_password_within + 1.minute).ago)
    post "/api/v1/password/verify", params: { code: code }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
