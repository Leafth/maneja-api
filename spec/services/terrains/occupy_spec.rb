require 'rails_helper'

RSpec.describe Terrains::Occupy, type: :service do
  describe '.call' do
    it "marks the terrain as occupied" do
      terrain = create(:terrain)
      result = described_class.call(terrain:)
      expect(result).to be_occupied
      expect(terrain.reload).to be_occupied
    end
  end
end
