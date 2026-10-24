require 'rails_helper'

RSpec.describe "POST /api/v1/feeds/:feed_id/movements/exit", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "creates an exit movement for a feed" do
    feed = create(:feed, user: user, stock_quantity: 100)
    post "/api/v1/feeds/#{feed.id}/movements/exit", params: { exit: {
      quantity: 50,
      reason: "Sold",
      occurred_on: Date.current
    } }, headers: headers, as: :json

    expect(response).to have_http_status(:created)
    body = response.parsed_body
    expect(body).to include(
      "feed_id" => feed.id,
      "movement_type" => "exit",
      "quantity" => "50.0",
      "reason" => "Sold",
      "occurred_on" => Date.current.to_s
    )
    expect(feed.reload.stock_quantity).to eq(50)
  end

  it "returns unprocessable content when attributes are invalid" do
    feed = create(:feed, user: user, stock_quantity: 100)
    post "/api/v1/feeds/#{feed.id}/movements/exit", params: { exit: {
      quantity: 150,
      reason: "Sold",
      occurred_on: Date.current
    } }, headers: headers, as: :json

    expect(response).to have_http_status(:unprocessable_content)
    expect(feed.reload.stock_quantity).to eq(100)
  end

  it "returns unprocessable content when stock quantity is insufficient" do
    feed = create(:feed, user: user, stock_quantity: 30)
    post "/api/v1/feeds/#{feed.id}/movements/exit", params: { exit: {
      quantity: 50,
      reason: "Sold",
      occurred_on: Date.current
    } }, headers: headers, as: :json

    expect(response).to have_http_status(:unprocessable_content)
    expect(feed.reload.stock_quantity).to eq(30)
  end

  it "returns not found when the feed does not exist" do
    post "/api/v1/feeds/#{SecureRandom.uuid}/movements/exit", params: { exit: {
      quantity: 50,
      reason: "Sold",
      occurred_on: Date.current
    } }, headers: headers, as: :json

    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    feed = create(:feed, user: user, stock_quantity: 100)
    post "/api/v1/feeds/#{feed.id}/movements/exit", params: { exit: {
      quantity: 50,
      reason: "Sold",
      occurred_on: Date.current
    } }, as: :json

    expect(response).to have_http_status(:unauthorized)
  end

  it "returns not found for another user's feed even when stock is insufficient" do
    feed = create(:feed, stock_quantity: 0)
    post "/api/v1/feeds/#{feed.id}/movements/exit", params: { exit: {
      quantity: 50,
      reason: "Sold",
      occurred_on: Date.current
    } }, headers: headers, as: :json

    expect(response).to have_http_status(:not_found)
  end
end
