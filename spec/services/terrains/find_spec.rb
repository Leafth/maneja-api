require 'rails_helper'

RSpec.describe Terrains::Find, type: :service do
  describe ".call" do
    let(:user) { create(:user) }

    it "returns an active terrain" do
      terrain = create(:terrain, user:)
      result = described_class.call(user: user, id: terrain.id)
      expect(result).to eq(terrain)
    end

    it "raises an error when the terrain is deleted" do
      terrain = create(:terrain, :deleted, user:)
      expect { described_class.call(user: user, id: terrain.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error when the terrain does not exist" do
      expect { described_class.call(user: user, id: SecureRandom.uuid) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error when the terrain belongs to another user" do
      terrain = create(:terrain)

      expect { described_class.call(user:, id: terrain.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
