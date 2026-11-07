require "rails_helper"

RSpec.describe "DESTROY /api/v1/groups/:group_id/feed_requirements/:id", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  let (:group) { create(:group, user:) }
  let (:feed_requirement) { create(:feed_requirement, group:, feed: create(:feed, user:)) }

  it "destroys the feed requirement" do
    delete "/api/v1/groups/#{group.id}/feed_requirements/#{feed_requirement.id}", headers: headers
    expect(response).to have_http_status(:no_content)
    expect { feed_requirement.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "returns not found when feed requirement belongs to another group" do
    other_group = create(:group, user:)
    delete "/api/v1/groups/#{other_group.id}/feed_requirements/#{feed_requirement.id}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns not found when group belongs to another user" do
    other_user = create(:user)
    other_group = create(:group, user: other_user)
    other_feed_requirement = create(:feed_requirement, group: other_group, feed: create(:feed, user: other_user))
    delete "/api/v1/groups/#{other_group.id}/feed_requirements/#{other_feed_requirement.id}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    delete "/api/v1/groups/#{group.id}/feed_requirements/#{feed_requirement.id}"
    expect(response).to have_http_status(:unauthorized)
  end
end
