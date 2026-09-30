require 'rails_helper'

RSpec.describe Terrains::Update, type: :service do
  describe ".call" do
    it "updates the terrain" do
      terrain = create(:terrain)
      result = described_class.call(id: terrain.id, attributes: { name: "Updated Terrain", rest_days: 20 })
      expect(result).to have_attributes(name: "Updated Terrain", rest_days: 20)
    end

    it "persists the changes" do
      terrain = create(:terrain)
      described_class.call(id: terrain.id, attributes: { name: "Updated Terrain" })
      expect(terrain.reload.name).to eq("Updated Terrain")
    end

    it "raises an error if the attributes are invalid" do
      terrain = create(:terrain)
      expect {
        described_class.call(id: terrain.id, attributes: { rest_days: -5 })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "raises an error if the terrain is deleted" do
      terrain = create(:terrain, :deleted)
      expect {
        described_class.call(id: terrain.id, attributes: { name: "Updated Terrain" })
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error if the terrain does not exist" do
      expect {
        described_class.call(id: SecureRandom.uuid, attributes: { name: "Updated Terrain" })
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
