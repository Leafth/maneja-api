require 'rails_helper'

RSpec.describe Terrains::Deactivate, type: :service do
  describe ".call" do
    let(:user) { create(:user) }

    it "deactivates an available terrain" do
      terrain = create(:terrain, user:)
      result = described_class.call(user: user, id: terrain.id)
      expect(result.deleted?).to be true
      expect(result.deleted_at).to be_present
    end

    it "keeps the terrain persisted" do
      terrain = create(:terrain, user:)
      expect { described_class.call(user: user, id: terrain.id) }.not_to change(Terrain, :count)
    end

    it "deactivates a resting terrain" do
      terrain = create(:terrain, :resting, user:)
      result = described_class.call(user: user, id: terrain.id)
      expect(result.reload).to be_deleted
    end

    it "does not deactivate a terrain with an active occupation" do
      terrain = create(:terrain, :occupied, user:)
      create(:occupation, terrain:, group: create(:group, user:))
      expect {
        described_class.call(user: user, id: terrain.id)
      }.to raise_error(Occupations::DeactivationError)
      expect(terrain.reload).not_to be_deleted
    end

    it "removes the terrain from the active scope" do
      terrain = create(:terrain, user:)
      described_class.call(user: user, id: terrain.id)
      expect(Terrain.active).not_to include(terrain)
    end

    it "raises an error if the terrain is already deleted" do
      terrain = create(:terrain, :deleted, user:)
      expect {
        described_class.call(user: user, id: terrain.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error if the terrain is not found" do
      expect {
        described_class.call(user: user, id: SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not change another user's occupied terrain or its occupation" do
      terrain = create(:terrain, :occupied)
      group = create(:group, user: terrain.user)
      occupation = create(:occupation, group:, terrain:)

      expect {
        described_class.call(user:, id: terrain.id)
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(terrain.reload).not_to be_deleted
      expect(terrain).to be_occupied
      expect(occupation.reload).to be_active
    end
  end
end
