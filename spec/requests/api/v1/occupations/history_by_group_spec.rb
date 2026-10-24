require 'rails_helper'

RSpec.describe "GET /api/v1/groups/:id/occupations", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "returns the occupations for the group" do
    group = create(:group, user:)
    occupation = create(:occupation, group:)
    create(:occupation)
    get "/api/v1/groups/#{group.id}/occupations", headers: headers
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body["data"].pluck("id")).to eq([ occupation.id ])
    expect(body["group"]["id"]).to eq(group.id)
    expect(body["meta"]["total_items"]).to eq(1)
  end

  it "returns unauthorized without valid authentication" do
    group = create(:group, user:)
    get "/api/v1/groups/#{group.id}/occupations"
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns not found for another user's group" do
    group = create(:group)
    create(:occupation, group:)
    get "/api/v1/groups/#{group.id}/occupations", headers: headers

    expect(response).to have_http_status(:not_found)
  end
end
