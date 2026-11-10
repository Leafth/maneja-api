require "rails_helper"

RSpec.describe "POST /api/v1/feed_planning", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "calculates the feed planning for a single group" do
    group = create(:group, user:, animal_count: 10)
    feed = create(:feed, user:, stock_quantity: 100)
    create(:feed_requirement, group:, feed:, quantity_per_animal_kg: 2)

    post "/api/v1/feed_planning", headers: headers, params: {
      feed_planning: {
        scope: "group",
        group_id: group.id,
        start_date: Date.today,
        end_date: Date.today + 4
      }
    }

    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['period']).to eq({
      'start_date' => Date.today.to_s,
      'end_date' => (Date.today + 4).to_s,
      'days' => 5
    })
    expect(body['scope']).to eq({ 'type' => "group", 'group_id' => group.id })
    expect(body['data'].size).to eq(1)
    expect(body['data']).to eq([
      {
        'feed_id' => feed.id,
        'feed_name' => feed.name,
        'stock_quantity' => "100.0",
        'required_quantity' => "100.0",
        'missing_quantity' => "0.0",
        'sufficient' => true
      }
    ])
  end

  it "calculates the feed planning for all groups" do
    group_one = create(:group, user:, animal_count: 10)
    group_two = create(:group, user:, animal_count: 20)
    feed = create(:feed, user:, stock_quantity: 100)
    create(:feed_requirement, group: group_one, feed:, quantity_per_animal_kg: 2)
    create(:feed_requirement, group: group_two, feed:, quantity_per_animal_kg: 3)

    post "/api/v1/feed_planning", headers: headers, params: {
      feed_planning: {
        scope: "all",
        start_date: Date.today,
        end_date: Date.today + 4
      }
    }

    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['period']).to eq({
      'start_date' => Date.today.to_s,
      'end_date' => (Date.today + 4).to_s,
      'days' => 5
    })
    expect(body['scope']).to eq({ 'type' => "all" })
    expect(body['data'].size).to eq(1)
    expect(body['data']).to eq([
      {
        'feed_id' => feed.id,
        'feed_name' => feed.name,
        'stock_quantity' => "100.0",
        'required_quantity' => "400.0",
        'missing_quantity' => "300.0",
        'sufficient' => false
      }
    ])
  end

  it "returns an error when the start date is after the end date" do
    post "/api/v1/feed_planning", headers: headers, params: {
      feed_planning: {
        scope: "all_groups",
        start_date: Date.today + 4,
        end_date: Date.today
      }
    }

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "returns an error when the group_id is missing for group scope" do
    post "/api/v1/feed_planning", headers: headers, params: {
      feed_planning: {
        scope: "group",
        start_date: Date.today,
        end_date: Date.today + 4
      }
    }

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "returns an error when the scope is invalid" do
    post "/api/v1/feed_planning", headers: headers, params: {
      feed_planning: {
        scope: "invalid_scope",
        start_date: Date.today,
        end_date: Date.today + 4
      }
    }

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "returns not found when the group belongs to another user" do
    other_user = create(:user)
    group = create(:group, user: other_user, animal_count: 10)

    post "/api/v1/feed_planning", headers: headers, params: {
      feed_planning: {
        scope: "group",
        group_id: group.id,
        start_date: Date.today,
        end_date: Date.today + 4
      }
    }

    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    post "/api/v1/feed_planning", params: {
      feed_planning: {
        scope: "all_groups",
        start_date: Date.today,
        end_date: Date.today + 4
      }
    }

    expect(response).to have_http_status(:unauthorized)
  end
end
