require 'rails_helper'

RSpec.describe "PATCH /api/v1/feeds/:id", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "updates the feed name" do
    feed = create(:feed, user: user, name: "Old Name")
    patch "/api/v1/feeds/#{feed.id}", params: { feed: { name: "New Name" } }, headers: headers, as: :json
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body).to include(
      "id" => feed.id,
      "name" => "New Name",
      "stock_quantity" => feed.stock_quantity.to_s("F")
    )
    expect(feed.reload.name).to eq("New Name")
  end

  it "does not update the stock quantity directly" do
    feed = create(:feed, user: user, stock_quantity: 10)
    patch "/api/v1/feeds/#{feed.id}", params: { feed: { name: feed.name, stock_quantity: 20, initial_stock_quantity: 30 } }, headers: headers, as: :json
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body).to include(
      "id" => feed.id,
      "name" => feed.name,
      "stock_quantity" => feed.stock_quantity.to_s("F")
    )
    expect(feed.reload.stock_quantity).to eq(10)
  end

  it "returns validation errors when the attributes are invalid" do
    feed = create(:feed, user:)
    patch "/api/v1/feeds/#{feed.id}", params: { feed: { name: "" } }, headers: headers, as: :json
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body["errors"]["name"]).to be_present
  end

  it "returns not found when the feed does not exist" do
    patch "/api/v1/feeds/#{SecureRandom.uuid}", params: { feed: { name: "New Name" } }, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    feed = create(:feed, user:)
    patch "/api/v1/feeds/#{feed.id}", params: { feed: { name: "New Name" } }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns not found without updating another user's feed" do
    feed = create(:feed, name: "Original Name")
    patch "/api/v1/feeds/#{feed.id}", params: { feed: { name: "New Name" } }, headers: headers, as: :json

    expect(response).to have_http_status(:not_found)
    expect(feed.reload.name).to eq("Original Name")
  end
end
