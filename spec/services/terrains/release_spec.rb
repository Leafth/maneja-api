require 'rails_helper'

RSpec.describe Terrains::Release, type: :service do
  describe '.call' do
    it "marks the terrain as available" do
      terrain = create(:terrain, :resting)
      result = described_class.call(terrain:)
      expect(result).to be_available
      expect(terrain.reload).to be_available
    end
  end
end
