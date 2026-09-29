require 'rails_helper'

RSpec.describe "GET /api/v1/groups/:id", type: :request do
  let(:user) { create(:user) }
  let(:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    { 'Authorization' => "Bearer #{tokens[:access_token]}" }
  end

  it "returns the group with the given id" do
    group = create(:group)
    get "/api/v1/groups/#{group.id}", headers: headers
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body).to include(
      "id" => group.id,
      "name" => group.name,
      "animal_count" => group.animal_count
    )
  end

  it "returns not found when the group does not exist" do
    get "/api/v1/groups/#{SecureRandom.uuid}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    group = create(:group)
    get "/api/v1/groups/#{group.id}"
    expect(response).to have_http_status(:unauthorized)
  end
end
