require 'rails_helper'

RSpec.describe "GET /api/v1/terrains/:id/occupations", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "returns the occupations for the terrain" do
    terrain = create(:terrain, user:)
    occupation = create(:occupation, terrain:, group: create(:group, user:))
    get "/api/v1/terrains/#{terrain.id}/occupations", headers: headers
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body["data"].pluck("id")).to eq([ occupation.id ])
  end

  it "returns unauthorized without valid authentication" do
    terrain = create(:terrain, user:)
    get "/api/v1/terrains/#{terrain.id}/occupations"
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns not found for another user's terrain" do
    terrain = create(:terrain)
    create(:occupation, terrain:, group: create(:group, user: terrain.user))
    get "/api/v1/terrains/#{terrain.id}/occupations", headers: headers

    expect(response).to have_http_status(:not_found)
  end
end
