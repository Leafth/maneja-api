require 'rails_helper'

RSpec.describe Terrains::Find, type: :service do
  describe ".call" do
    it "returns an active terrain" do
      terrain = create(:terrain)
      result = described_class.call(id: terrain.id)
      expect(result).to eq(terrain)
    end

    it "raises an error when the terrain is deleted" do
      terrain = create(:terrain, :deleted)
      expect { described_class.call(id: terrain.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error when the terrain does not exist" do
      expect { described_class.call(id: SecureRandom.uuid) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
