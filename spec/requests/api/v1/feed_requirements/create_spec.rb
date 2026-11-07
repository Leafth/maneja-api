require "rails_helper"

RSpec.describe "POST /api/v1/groups/:group_id/feed_requirements", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  let (:group) { create(:group, user:) }
  let (:feed) { create(:feed, user:) }

  let(:valid_params) do
    {
      feed_requirement: {
        feed_id: feed.id,
        quantity_per_animal_kg: 5.0
      }
    }
  end

  it "creates a feed requirement" do
    post "/api/v1/groups/#{group.id}/feed_requirements", params: valid_params, headers: headers, as: :json
    expect(response).to have_http_status(:created)
    expect(FeedRequirement.find(response.parsed_body["id"]).group).to eq(group)
    expect(FeedRequirement.find(response.parsed_body["id"]).feed).to eq(feed)
    expect(response.parsed_body).to include(
      "id" => be_present,
      "group_id" => group.id,
      "feed_id" => feed.id,
      "quantity_per_animal_kg" => "5.0"
    )
  end

  it "returns validation errors with invalid attributes" do
    post "/api/v1/groups/#{group.id}/feed_requirements", params: { feed_requirement: { feed_id: feed.id, quantity_per_animal_kg: 0 } }, headers: headers, as: :json
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body["errors"]["quantity_per_animal_kg"]).to be_present
  end

  it "returns not found if the group does not belong to the user" do
    other_user = create(:user)
    other_group = create(:group, user: other_user)
    post "/api/v1/groups/#{other_group.id}/feed_requirements", params: valid_params, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns not found if the feed does not belong to the user" do
    other_user = create(:user)
    other_feed = create(:feed, user: other_user)
    post "/api/v1/groups/#{group.id}/feed_requirements",
          params: {
            feed_requirement: {
              feed_id: other_feed.id,
              quantity_per_animal_kg: 5.0
            }
          }, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized without valid authentication" do
    post "/api/v1/groups/#{group.id}/feed_requirements", params: valid_params, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
