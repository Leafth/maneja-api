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

  it "returns unauthorized if no token is provided" do
    get "/api/v1/overview"

    expect(response).to have_http_status(:unauthorized)
  end
end
