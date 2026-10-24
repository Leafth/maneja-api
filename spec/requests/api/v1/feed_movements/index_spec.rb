require 'rails_helper'

RSpec.describe "GET /api/v1/feeds/:feed_id/movements", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "returns a list of feed movements for the given feed" do
    feed = create(:feed, user: user, stock_quantity: 100)
    create(:feed_movement, feed:, movement_type: "entry", quantity: 50, value: 200, occurred_on: Date.current)
    create(:feed_movement, feed:, movement_type: "exit", quantity: 30, reason: "Sold", occurred_on: Date.current)
    get "/api/v1/feeds/#{feed.id}/movements", headers: headers
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['data'].size).to eq(2)
    expect(body['data'].pluck('movement_type')).to match_array([ "entry", "exit" ])
  end

  it "returns a paginated list of feed movements" do
    feed = create(:feed, user: user, stock_quantity: 100)
    create_list(:feed_movement, 3, feed:, movement_type: "entry", quantity: 50, value: 200, occurred_on: Date.current)
    create_list(:feed_movement, 2)
    get "/api/v1/feeds/#{feed.id}/movements", headers: headers, params: { page: 1, per_page: 2 }
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

  it "returns not found when the feed does not exist" do
    get "/api/v1/feeds/#{SecureRandom.uuid}/movements", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    feed = create(:feed, user: user, stock_quantity: 100)
    get "/api/v1/feeds/#{feed.id}/movements"
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns not found for another user's feed" do
    feed = create(:feed)
    create(:feed_movement, feed:)
    get "/api/v1/feeds/#{feed.id}/movements", headers: headers

    expect(response).to have_http_status(:not_found)
  end
end
