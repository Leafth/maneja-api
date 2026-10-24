require 'rails_helper'

RSpec.describe "POST /api/v1/occupations", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  let(:group) { create(:group, user:) }
  let(:terrain) { create(:terrain, user:) }

  it "creates the current occupation" do
    post "/api/v1/occupations",
      params: {
        occupation: { group_id: group.id, terrain_id: terrain.id }
      }, headers: headers, as: :json

    body = response.parsed_body
    expect(response).to have_http_status(:created)
    expect(body).to include(
      "id" => be_present,
      "started_at" => be_present,
      "ended_at" => nil
    )
    expect(body["group"]).to include(
      "id" => group.id,
      "name" => group.name
    )
    expect(body["terrain"]).to include(
      "id" => terrain.id,
      "name" => terrain.name
    )
  end

  it "returns not found when the group does not exist" do
    post "/api/v1/occupations",
      params: {
        occupation: { group_id: SecureRandom.uuid, terrain_id: terrain.id }
      }, headers: headers, as: :json

    expect(response).to have_http_status(:not_found)
  end

  it "returns not found when the terrain does not exist" do
    post "/api/v1/occupations",
      params: {
        occupation: { group_id: group.id, terrain_id: SecureRandom.uuid }
      }, headers: headers, as: :json

    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized without valid authentication" do
    post "/api/v1/occupations",
      params: {
        occupation: { group_id: group.id, terrain_id: terrain.id }
      }, as: :json

    expect(response).to have_http_status(:unauthorized)
  end

  it "returns not found for a destination belonging to another user" do
    destination = create(:terrain, :occupied)
    post "/api/v1/occupations", params: {
      occupation: { group_id: group.id, terrain_id: destination.id }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:not_found)
  end

  it "returns not found for a group belonging to another user" do
    other_group = create(:group)
    post "/api/v1/occupations", params: {
      occupation: { group_id: other_group.id, terrain_id: terrain.id }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:not_found)
  end
end
