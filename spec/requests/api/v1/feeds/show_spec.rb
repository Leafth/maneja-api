require 'rails_helper'

RSpec.describe "GET /api/v1/feeds/:id", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "returns a feed with the given id" do
    feed = create(:feed)
    get "/api/v1/feeds/#{feed.id}", headers: headers
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body).to include(
      "id" => feed.id,
      "name" => feed.name,
      "stock_quantity" => feed.stock_quantity.to_s("F")
    )
  end

  it "returns not found when the feed does not exist" do
    get "/api/v1/feeds/#{SecureRandom.uuid}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    feed = create(:feed)
    get "/api/v1/feeds/#{feed.id}"
    expect(response).to have_http_status(:unauthorized)
  end
end
