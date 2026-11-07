require "rails_helper"

RSpec.describe "GET /api/v1/groups/:group_id/feed_requirements", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  let (:group) { create(:group, user:) }

  it "returns feed requirements for the group" do
    feed_requirement = create(:feed_requirement, group:, feed: create(:feed, user:))
    other_feed_requirement = create(:feed_requirement, group:, feed: create(:feed, user:))
    get "/api/v1/groups/#{group.id}/feed_requirements", headers: headers
    expect(response).to have_http_status(:ok)
    body = response.parsed_body
    expect(body["group_id"]).to eq(group.id)
    expect(body["feed_requirements"].size).to eq(2)
    expect(body["feed_requirements"].pluck('id')).to match_array([ feed_requirement.id, other_feed_requirement.id ])
  end

  it "returns an empty collection if the group has no feed requirements" do
    get "/api/v1/groups/#{group.id}/feed_requirements", headers: headers
    expect(response).to have_http_status(:ok)
    body = response.parsed_body
    expect(body["group_id"]).to eq(group.id)
    expect(body["feed_requirements"]).to be_empty
  end

  it "returns not found when group belongs to another user" do
    other_user = create(:user)
    other_group = create(:group, user: other_user)
    get "/api/v1/groups/#{other_group.id}/feed_requirements", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    get "/api/v1/groups/#{group.id}/feed_requirements"
    expect(response).to have_http_status(:unauthorized)
  end
end
