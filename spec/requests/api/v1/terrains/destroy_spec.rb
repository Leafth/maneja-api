require 'rails_helper'

RSpec.describe "DELETE /api/v1/terrains/:id", type: :request do
  let (:user) { create(:user) }
  let (:tokens) { Auth::CreateSession.call(user:) }

  let(:headers) do
    {
      "Authorization" => "Bearer #{tokens[:access_token]}"
    }
  end

  it "deletes a terrain" do
    terrain = create(:terrain)
    delete "/api/v1/terrains/#{terrain.id}", headers: headers
    expect(response).to have_http_status(:no_content)
  end

  it "returns not found when the terrain does not exist" do
    delete "/api/v1/terrains/#{SecureRandom.uuid}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "returns unauthorized when no token is provided" do
    terrain = create(:terrain)
    delete "/api/v1/terrains/#{terrain.id}"
    expect(response).to have_http_status(:unauthorized)
  end
end
