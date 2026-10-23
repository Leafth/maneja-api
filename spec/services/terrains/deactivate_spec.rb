require 'rails_helper'

RSpec.describe Terrains::Deactivate, type: :service do
  describe ".call" do
    it "deactivates an available terrain" do
      terrain = create(:terrain)
      result = described_class.call(id: terrain.id)
      expect(result.deleted?).to be true
      expect(result.deleted_at).to be_present
    end

    it "keeps the terrain persisted" do
      terrain = create(:terrain)
      expect { described_class.call(id: terrain.id) }.not_to change(Terrain, :count)
    end

    it "deactivates a resting terrain" do
      terrain = create(:terrain, :resting)
      result = described_class.call(id: terrain.id)
      expect(result.reload).to be_deleted
    end

    it "does not deactivate a terrain with an active occupation" do
      terrain = create(:terrain, :occupied)
      create(:occupation, terrain:)
      expect {
        described_class.call(id: terrain.id)
      }.to raise_error(Occupations::DeactivationError)
      expect(terrain.reload).not_to be_deleted
    end

    it "removes the terrain from the active scope" do
      terrain = create(:terrain)
      described_class.call(id: terrain.id)
      expect(Terrain.active).not_to include(terrain)
    end

    it "raises an error if the terrain is already deleted" do
      terrain = create(:terrain, :deleted)
      expect {
        described_class.call(id: terrain.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error if the terrain is not found" do
      expect {
        described_class.call(id: SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
