require 'rails_helper'

RSpec.describe "DELETE /api/v1/feeds/:id", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "soft deletes the feed" do
    feed = create(:feed, user:)
    delete "/api/v1/feeds/#{feed.id}", headers: headers
    expect(response).to have_http_status(:no_content)
    expect(feed.reload).to be_deleted
  end

  it "returns not found when the feed does not exist" do
    delete "/api/v1/feeds/#{SecureRandom.uuid}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns not found when the feed is already deleted" do
    feed = create(:feed, :deleted, user:)
    delete "/api/v1/feeds/#{feed.id}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    feed = create(:feed, user:)
    delete "/api/v1/feeds/#{feed.id}"
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns not found for another user's feed" do
    feed = create(:feed)
    delete "/api/v1/feeds/#{feed.id}", headers: headers

    expect(response).to have_http_status(:not_found)
  end
end
