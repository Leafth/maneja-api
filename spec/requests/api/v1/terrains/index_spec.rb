require 'rails_helper'

RSpec.describe "GET /api/v1/terrains", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "filters terrains" do
    matching_terrain = create(:terrain, name: "North Pasture")
    create(:terrain, name: "South Pasture")
    get "/api/v1/terrains", headers: headers, params: { name: "North" }
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['data'].pluck('id')).to eq([ matching_terrain.id ])
  end

  it "sorts terrains" do
    shorter_rest = create(:terrain, rest_days: 5)
    longer_rest = create(:terrain, rest_days: 20)
    get "/api/v1/terrains", headers: headers, params: { sort: "rest_days", direction: "desc" }
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['data'].pluck('id')).to eq([ longer_rest.id, shorter_rest.id ])
  end

  it "returns a paginated list of terrains" do
    create_list(:terrain, 3)
    get "/api/v1/terrains", headers: headers, params: { page: 1, per_page: 2 }
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['data'].size).to eq(2)
    expect(body['meta']).to include(
      'page' => 1,
      'per_page' => 2,
      'total_items' => 3,
      'total_pages' => 2
    )
  end

  it "returns serialized terrain attributes" do
    terrain = create(:terrain)
    get "/api/v1/terrains", headers: headers
    serialized_terrain = response.parsed_body['data'].first
    expect(serialized_terrain).to include(
      'id' => terrain.id,
      'name' => terrain.name,
      'rest_days' => terrain.rest_days,
      'status' => terrain.status
    )
  end

  it "retrurns unauthorized when no token is provided" do
    get "/api/v1/terrains"
    expect(response).to have_http_status(:unauthorized)
  end
end
