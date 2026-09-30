require 'rails_helper'

RSpec.describe "GET /api/v1/terrains/:id", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "returns a terrain" do
    terrain = create(:terrain)
    get "/api/v1/terrains/#{terrain.id}", headers: headers
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body).to include(
      'id' => terrain.id,
      'name' => terrain.name,
      'rest_days' => terrain.rest_days,
      'status' => terrain.status
    )
  end

  it "returns not found when the terrain is deleted" do
    terrain = create(:terrain, :deleted)
    get "/api/v1/terrains/#{terrain.id}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns not found when the terrain does not exist" do
    get "/api/v1/terrains/#{SecureRandom.uuid}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    terrain = create(:terrain)
    get "/api/v1/terrains/#{terrain.id}"
    expect(response).to have_http_status(:unauthorized)
  end
end
