require "rails_helper"

RSpec.describe "GET /api/v1/overview", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "returns the herd overview" do
    create(:group, user:, animal_count: 40)
    create(:group, user:, animal_count: 61)
    create(:group, :deleted, user:, animal_count: 100)

    get "/api/v1/overview", headers: headers

    body = response.parsed_body
    expect(response).to have_http_status(:ok)

    expect(body["herd"]).to eq({
      "groups" => 2,
      "animals" => 101
    })
  end

  it "does not include groups from other users" do
    create(:group, user:, animal_count: 40)
    other_user = create(:user)
    create(:group, user: other_user, animal_count: 100)

    get "/api/v1/overview", headers: headers

    body = response.parsed_body
    expect(response).to have_http_status(:ok)

    expect(body["herd"]).to eq({
      "groups" => 1,
      "animals" => 40
    })
  end

  it "returns the terrains overview" do
    create(:terrain, :available, user:,)
    create(:terrain, :occupied, user:,)
    create(:terrain, :resting, user:,)
    create(:terrain, :deleted, user:,)
    create(:terrain, :occupied, user:,)

    get "/api/v1/overview", headers: headers

    body = response.parsed_body
    expect(response).to have_http_status(:ok)

    expect(body["terrains"]).to eq({
      "total" => 4,
      "available" => 1,
      "occupied" => 2,
      "resting" => 1
    })
  end

  it "return the most relevant feed alerts" do
    group = create(:group, user:, animal_count: 10)
    critical_feed = create(:feed, user:, stock_quantity: 20)
    urgency_feed = create(:feed, user:, stock_quantity: 100)
    attention_feed = create(:feed, user:, stock_quantity: 200)
    info_feed = create(:feed, user:, stock_quantity: 500)

    create(:feed_requirement, group:, feed: critical_feed, quantity_per_animal_kg: 1)
    create(:feed_requirement, group:, feed: urgency_feed, quantity_per_animal_kg: 1)
    create(:feed_requirement, group:, feed: attention_feed, quantity_per_animal_kg: 1)
    create(:feed_requirement, group:, feed: info_feed, quantity_per_animal_kg: 1)

    get "/api/v1/overview", headers: headers

    body = response.parsed_body
    expect(response).to have_http_status(:ok)

    expect(body["feed_alerts"].pluck("feed_id")).to eq([
      critical_feed.id,
      urgency_feed.id,
      attention_feed.id
    ])
  end

  it "returns unauthorized if no token is provided" do
    get "/api/v1/overview"

    expect(response).to have_http_status(:unauthorized)
  end
end
