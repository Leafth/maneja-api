require 'rails_helper'

RSpec.describe "DELETE /api/v1/groups/:id", type: :request do
  let(:user) { create(:user) }
  let(:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    { 'Authorization' => "Bearer #{tokens[:access_token]}" }
  end

  it "soft deletes the group" do
    group = create(:group)
    delete "/api/v1/groups/#{group.id}", headers: headers
    expect(response).to have_http_status(:no_content)
    expect(group.reload).to be_deleted
  end

  it "returns not found when the group does not exist" do
    delete "/api/v1/groups/#{SecureRandom.uuid}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    group = create(:group)
    delete "/api/v1/groups/#{group.id}"
    expect(response).to have_http_status(:unauthorized)
  end
end
