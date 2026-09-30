require 'rails_helper'

RSpec.describe "PATCH /api/v1/terrains/:id", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "updates a terrain" do
    terrain = create(:terrain)
    patch "/api/v1/terrains/#{terrain.id}", params: { terrain: { name: "Updated Terrain" } }, headers: headers, as: :json
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body).to include(
      'id' => terrain.id,
      'name' => "Updated Terrain",
      'rest_days' => terrain.rest_days,
      'status' => terrain.status
    )
  end

  it "return validation errors when the attributes are invalid" do
    terrain = create(:terrain)
    patch "/api/v1/terrains/#{terrain.id}", params: { terrain: { rest_days: -5 } }, headers: headers, as: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.parsed_body["errors"]["rest_days"]).to be_present
  end

  it "returns not found when the terrain does not exist" do
    patch "/api/v1/terrains/#{SecureRandom.uuid}", params: { terrain: { name: "Updated Terrain" } }, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    terrain = create(:terrain)
    patch "/api/v1/terrains/#{terrain.id}", params: { terrain: { name: "Updated Terrain" } }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
