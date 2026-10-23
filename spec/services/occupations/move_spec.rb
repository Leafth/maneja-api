require 'rails_helper'

RSpec.describe Occupations::Move, type: :service do
  describe '.call' do
    let (:group) { create(:group) }

    it "moves the occupation without a current occupation to a terrain" do
      destination = create(:terrain)
      occupation = described_class.call(group:, destination:)
      expect(occupation).to be_persisted
      expect(occupation).to have_attributes(group:, terrain: destination, ended_at: nil)
      expect(destination.reload).to be_occupied
    end

    it "moves a group from one terrain to another" do
      origin = create(:terrain, :occupied, rest_days: 10)
      destination = create(:terrain)
      previous_occupation = create(:occupation, group:, terrain: origin)
      occupation = described_class.call(group:, destination:)
      expect(previous_occupation.reload).to be_finished
      expect(origin.reload).to be_resting
      expect(occupation).to be_active
      expect(occupation.terrain).to eq(destination)
      expect(destination.reload).to be_occupied
    end

    it "makes the origin terrain when it does not require rest" do
      origin = create(:terrain, :occupied, rest_days: 0)
      destination = create(:terrain)
      create(:occupation, group:, terrain: origin)
      described_class.call(group:, destination:)
      expect(origin.reload).to be_available
    end

    it "allows movement to a resting terrain" do
      destination = create(:terrain, :resting)
      occupation = described_class.call(group:, destination:)
      expect(occupation.terrain).to eq(destination)
      expect(destination.reload).to be_occupied
    end

    it "does not change the current occupation when the movement is invalid" do
      origin = create(:terrain, :occupied, rest_days: 10)
      destination = create(:terrain, :occupied)
      current_occupation = create(:occupation, group:, terrain: origin)
      expect {
        described_class.call(group:, destination:)
      }.to raise_error(Occupations::MovementError)
      expect(current_occupation.reload).to be_active
      expect(origin.reload).to be_occupied
    end
  end
end
