require "rails_helper"

RSpec.describe "PATCH /api/v1/groups/:group_id/feed_requirements/:id", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  let (:group) { create(:group, user:) }
  let (:feed) { create(:feed, user:) }
  let (:feed_requirement) { create(:feed_requirement, group: group, feed: feed, quantity_per_animal_kg: 5.0) }

  it "updates the feed requirement" do
    new_feed = create(:feed, user:)
    patch "/api/v1/groups/#{group.id}/feed_requirements/#{feed_requirement.id}", params: {
      feed_requirement: {
        feed_id: new_feed.id,
        quantity_per_animal_kg: 4.2
      }
    }, headers: headers, as: :json
    expect(response).to have_http_status(:ok)
    body = response.parsed_body
    expect(body['id']).to eq(feed_requirement.id)
    expect(body['feed_id']).to eq(new_feed.id)
    expect(body['quantity_per_animal_kg'].to_d).to eq(4.2)
  end

  it "returns not found when feed belongs to another user" do
    other_user = create(:user)
    other_feed = create(:feed, user: other_user)
    patch "/api/v1/groups/#{group.id}/feed_requirements/#{feed_requirement.id}", params: {
      feed_requirement: {
        feed_id: other_feed.id,
        quantity_per_animal_kg: 4.2
      }
    }, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns not found when requirement belongs to another group" do
    other_group = create(:group, user:)
    patch "/api/v1/groups/#{other_group.id}/feed_requirements/#{feed_requirement.id}", params: {
      feed_requirement: {
        feed_id: feed.id,
        quantity_per_animal_kg: 4.2
      }
    }, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns not found when group belongs to another user" do
    other_user = create(:user)
    other_group = create(:group, user: other_user)
    patch "/api/v1/groups/#{other_group.id}/feed_requirements/#{feed_requirement.id}", params: {
      feed_requirement: {
        feed_id: feed.id,
        quantity_per_animal_kg: 4.2
      }
    }, headers: headers, as: :json
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    patch "/api/v1/groups/#{group.id}/feed_requirements/#{feed_requirement.id}", params: {
      feed_requirement: {
        feed_id: feed.id,
        quantity_per_animal_kg: 4.2
      }
    }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
