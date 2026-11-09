require "rails_helper"

RSpec.describe "GET /api/v1/groups/:group_id/feedings", type: :request do
  let (:user) { create(:user) }
  let (:token) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{token[:access_token]}"
    }
  end

  let (:group) { create(:group, user:) }
  let (:feed) { create(:feed, user:) }

  it "returns a list of feedings for the specified group" do
    create(:feeding, group:, feed:, quantity: 10.0, occurred_at: 1.day.ago)
    create(:feeding, group:, feed:, quantity: 5.0, occurred_at: 2.days.ago)
    get "/api/v1/groups/#{group.id}/feedings", headers: headers
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['group_id']).to eq(group.id)
    expect(body['data'].size).to eq(2)
    expect(body['data'].pluck('quantity')).to match_array([ "10.0", "5.0" ])
  end

  it "returns paginated feedings" do
    create_list(:feeding, 3, group:, feed:, quantity: 10.0, occurred_at: 1.day.ago)
    create_list(:feeding, 2)
    get "/api/v1/groups/#{group.id}/feedings", headers: headers, params: { page: 1, per_page: 2 }
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

  it "returns not found if the group does not belong to the user" do
    other_user = create(:user)
    other_group = create(:group, user: other_user)
    get "/api/v1/groups/#{other_group.id}/feedings", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized if no token is provided" do
    get "/api/v1/groups/#{group.id}/feedings"
    expect(response).to have_http_status(:unauthorized)
  end
end
