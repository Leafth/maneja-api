require 'rails_helper'

RSpec.describe "POST /api/v1/terrains", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  let(:attributes) { attributes_for(:terrain) }

  it "creates a terrain with valid attributes" do
    post "/api/v1/terrains", params: { terrain: attributes }, headers: headers, as: :json
    expect(response).to have_http_status(:created)
    expect(Terrain.find(response.parsed_body["id"]).user).to eq(user)
    expect(response.parsed_body).to include(
      "id" => be_present,
      "name" => attributes[:name],
      "rest_days" => attributes[:rest_days],
      "status" => "available"
    )
  end

  it "returns validations errors with invalid attributes" do
    post "/api/v1/terrains", params: { terrain: attributes.merge(name: nil) }, headers: headers, as: :json
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body["errors"]["name"]).to be_present
  end

  it "returns unauthorized without valid authentication" do
    post "/api/v1/terrains", params: { terrain: attributes }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it "ignores ownership and status supplied by the client" do
    other_user = create(:user)
    post "/api/v1/terrains", params: {
      terrain: attributes.merge(user_id: other_user.id, status: "occupied")
    }, headers: headers, as: :json

    expect(response).to have_http_status(:created)
    terrain = Terrain.find(response.parsed_body["id"])
    expect(terrain.user).to eq(user)
    expect(terrain).to be_available
    expect(response.parsed_body).not_to have_key("user_id")
  end
end
