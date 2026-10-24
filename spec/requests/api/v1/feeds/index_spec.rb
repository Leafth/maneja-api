require 'rails_helper'

RSpec.describe "GET /api/v1/feeds", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "filters feeds" do
    matching_feed = create(:feed, user: user, name: "Premium Feed")
    create(:feed, user: user, name: "Basic Feed")
    get "/api/v1/feeds", headers: headers, params: { name: "Premium" }
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['data'].pluck('id')).to eq([ matching_feed.id ])
  end

  it "sorts feeds" do
    low_stock_feed = create(:feed, user: user, stock_quantity: 5)
    high_stock_feed = create(:feed, user: user, stock_quantity: 20)
    get "/api/v1/feeds", headers: headers, params: { sort: "stock_quantity", direction: "desc" }
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['data'].pluck('id')).to eq([ high_stock_feed.id, low_stock_feed.id ])
  end

  it "returns a paginated list of feeds" do
    create_list(:feed, 3, user: user)
    create_list(:feed, 2)
    get "/api/v1/feeds", headers: headers, params: { page: 1, per_page: 2 }
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
end
