require 'rails_helper'

RSpec.describe 'GET /api/v1/groups', type: :request do
  let(:user) { create(:user) }
  let(:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    { 'Authorization' => "Bearer #{tokens[:access_token]}" }
  end

  it 'returns a paginated list of groups' do
    create_list(:group, 3)
    get "/api/v1/groups", headers: headers, params: { page: 1, per_page: 2 }
    body = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(body['data'].size).to eq(2)
    expect(body['meta']).to include(
      'page' => 1,
      'per_page' => 2,
      'total_items' => 3,
      'total_pages' => 2
    )
  end

  it "returns serialized group attributes" do
    group = create(:group)
    get "/api/v1/groups", headers: headers
    serialized_group = response.parsed_body['data'].first
    expect(serialized_group).to include(
      'id' => group.id,
      'name' => group.name,
      'animal_count' => group.animal_count
    )
  end

  it "returns unauthorized when no token is provided" do
    get "/api/v1/groups"
    expect(response).to have_http_status(:unauthorized)
  end
end
