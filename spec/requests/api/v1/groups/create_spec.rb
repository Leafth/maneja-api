require 'rails_helper'

RSpec.describe "POST /api/v1/groups", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  let(:attributes) { attributes_for(:group) }

  it "creates a group with valid attributes" do
    post "/api/v1/groups", params: { group: attributes }, headers: headers, as: :json
    expect(response).to have_http_status(:created)
    expect(response.parsed_body).to include(
      "id" => be_present,
      "name" => attributes[:name],
      "animal_count" => attributes[:animal_count],
    )
  end

  it "returns validations errors with invalid attributes" do
    post "/api/v1/groups", params: { group: attributes.merge(name: nil) }, headers: headers, as: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.parsed_body["errors"]["name"]).to be_present
  end

  it "returns unauthorized without valid authentication" do
    post "/api/v1/groups", params: { group: attributes }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
