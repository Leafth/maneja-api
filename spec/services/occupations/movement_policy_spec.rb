require 'rails_helper'

RSpec.describe Occupations::MovementPolicy, type: :service do
  describe '.validate!' do
    let (:group) { create(:group) }
    let (:destination) { create(:terrain) }

    it "allows movement to an available terrain" do
      expect {
        described_class.validate!(group:, current_occupation: nil, destination:)
      }.not_to raise_error
    end

    it "allows movement to a resting terrain" do
      resting_terrain = create(:terrain, :resting)
      expect {
        described_class.validate!(group:, current_occupation: nil, destination: resting_terrain)
      }.not_to raise_error
    end

    it "does not allow movement to an occupied terrain" do
      occupied_terrain = create(:terrain, :occupied)
      expect {
        described_class.validate!(group:, current_occupation: nil, destination: occupied_terrain)
      }.to raise_error(Occupations::MovementError)
    end

    it "does not allow movement for an inactive group" do
      group.soft_delete!
      expect {
        described_class.validate!(group:, current_occupation: nil, destination:)
      }.to raise_error(Occupations::MovementError)
    end

    it "does not allow movement to an inactive terrain" do
      destination.soft_delete!
      expect {
        described_class.validate!(group:, current_occupation: nil, destination:)
      }.to raise_error(Occupations::MovementError)
    end

    it "does not allow movement to the same terrain" do
      current_occupation = create(:occupation, group:, terrain: destination)
      expect {
        described_class.validate!(group:, current_occupation:, destination:)
      }.to raise_error(Occupations::MovementError)
    end
  end
end
