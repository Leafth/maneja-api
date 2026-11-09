require "rails_helper"

RSpec.describe "POST /api/v1/groups/:group_id/feedings", type: :request do
  let (:user) { create(:user) }
  let (:token) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{token[:access_token]}"
    }
  end

  let (:group) { create(:group, user:) }
  let (:feed) { create(:feed, user:, stock_quantity: 100) }
  let (:occurred_at) { Time.zone.local(2026, 11, 7, 18, 30) }

  let(:valid_params) do
    {
      feeding: {
        feed_id: feed.id,
        quantity: 25.0,
        occurred_at:
      }
    }
  end

  it "creates a feeding" do
    post "/api/v1/groups/#{group.id}/feedings", params: valid_params, headers: headers, as: :json
    expect(response).to have_http_status(:created)
    expect(Feeding.find(response.parsed_body["id"]).group).to eq(group)
    expect(Feeding.find(response.parsed_body["id"]).feed).to eq(feed)
    expect(response.parsed_body).to include(
      "id" => be_present,
      "group_id" => group.id,
      "feed_id" => feed.id,
      "quantity" => "25.0",
      "occurred_at" => occurred_at.as_json
    )
  end

  it "returns validation errors with invalid attributes" do
    post "/api/v1/groups/#{group.id}/feedings", params: { feeding: { feed_id: feed.id, quantity: 0, occurred_at: } }, headers: headers, as: :json
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body["errors"]["quantity"]).to be_present
  end

  it "returns unprocessable content with insufficient stock" do
    post "/api/v1/groups/#{group.id}/feedings", params: { feeding: { feed_id: feed.id, quantity: 200.0, occurred_at: } }, headers: headers, as: :json
    expect(response).to have_http_status(:unprocessable_content)
    expect(feed.reload.stock_quantity).to eq(100)
  end

  it "returns not found if the group does not belong to the user" do
    other_user = create(:user)
    other_group = create(:group, user: other_user)
    post "/api/v1/groups/#{other_group.id}/feedings", params: valid_params, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns not found if the feed does not belong to the user" do
    other_user = create(:user)
    other_feed = create(:feed, user: other_user)
    post "/api/v1/groups/#{group.id}/feedings",
          params: {
            feeding: {
              feed_id: other_feed.id,
              quantity: 25.0,
              occurred_at:
            }
          }, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    post "/api/v1/groups/#{group.id}/feedings", params: valid_params, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
