require 'rails_helper'

RSpec.describe "PATCH /api/v1/groups/:id", type: :request do
  let(:user) { create(:user) }
  let(:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    { 'Authorization' => "Bearer #{tokens[:access_token]}" }
  end

  it "updates the group" do
    group = create(:group)
    patch "/api/v1/groups/#{group.id}", params: { group: { name: "Updated Name", animal_count: 20 } }, headers: headers, as: :json
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body).to include(
      "id" => group.id,
      "name" => "Updated Name",
      "animal_count" => 20
    )
  end

  it "returns validation errors when the attributes are invalid" do
    group = create(:group)
    patch "/api/v1/groups/#{group.id}", params: { group: { animal_count: -10 } }, headers: headers, as: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.parsed_body["errors"]["animal_count"]).to be_present
  end

  it "returns not found when the group does not exist" do
    patch "/api/v1/groups/#{SecureRandom.uuid}", params: { group: { name: "Updated Name" } }, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    group = create(:group)
    patch "/api/v1/groups/#{group.id}", params: { group: { name: "Updated Name" } }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
