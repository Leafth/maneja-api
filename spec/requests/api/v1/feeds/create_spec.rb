require 'rails_helper'

RSpec.describe "POST /api/v1/feeds", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  let(:valid_params) { { feed: { name: "Feed A", initial_stock_quantity: 100.5 } } }

  it "creates a feed with valid attributes" do
    post "/api/v1/feeds", params: valid_params, headers: headers, as: :json
    expect(response).to have_http_status(:created)
    expect(Feed.find(response.parsed_body["id"]).user).to eq(user)
    expect(response.parsed_body).to include(
      "id" => be_present,
      "name" => "Feed A",
      "stock_quantity" => "100.5",
    )
  end

  it "returns validation errors with invalid attributes" do
    post "/api/v1/feeds", params: { feed: { name: nil, initial_stock_quantity: -100 } }, headers: headers, as: :json
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body["errors"]["name"]).to be_present
  end

  it "returns unauthorized without valid authentication" do
    post "/api/v1/feeds", params: valid_params, as: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it "ignores ownership supplied by the client" do
    other_user = create(:user)
    post "/api/v1/feeds", params: {
      feed: valid_params[:feed].merge(user_id: other_user.id)
    }, headers: headers, as: :json

    expect(response).to have_http_status(:created)
    expect(Feed.find(response.parsed_body["id"]).user).to eq(user)
    expect(response.parsed_body).not_to have_key("user_id")
  end
end
