require 'rails_helper'

RSpec.describe "POST /api/v1/password/forgot", type: :request do
  before do
    ActionMailer::Base.deliveries.clear
  end

  it "sends a password reset email to the user" do
    user = create(:user)
    expect {
      post "/api/v1/password/forgot", params: { email: user.email }, as: :json
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect(response).to have_http_status(:no_content)
  end

  it "returns no content even if the email does not exist" do
    post "/api/v1/password/forgot", params: { email: Faker::Internet.unique.email }, as: :json
    expect(response).to have_http_status(:no_content)
  end

  it "does not send an email when the user does not exist" do
    expect {
      post "/api/v1/password/forgot", params: { email: Faker::Internet.unique.email }, as: :json
    }.not_to change(ActionMailer::Base.deliveries, :count)
    expect(response).to have_http_status(:no_content)
  end
end
