require 'rails_helper'

RSpec.describe Terrains::StartRest, type: :service do
  describe '.call' do
    it "marks the terrain as resting" do
      terrain = create(:terrain, :occupied, rest_days: 15)
      result = described_class.call(terrain:)
      expect(result).to be_resting
      expect(terrain.reload).to be_resting
    end

    it "releases the terrain immediately if rest_days is 0" do
      terrain = create(:terrain, :occupied, rest_days: 0)
      result = described_class.call(terrain:)
      expect(result).to be_available
      expect(terrain.reload).to be_available
    end
  end
end
