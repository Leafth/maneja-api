require 'rails_helper'

RSpec.describe Occupations::Move, type: :service do
  describe '.call' do
    let(:user) { create(:user) }
    let (:group) { create(:group, user:) }

    it "moves the occupation without a current occupation to a terrain" do
      destination = create(:terrain, user:)
      occupation = described_class.call(user: user, group:, destination:)
      expect(occupation).to be_persisted
      expect(occupation).to have_attributes(group:, terrain: destination, ended_at: nil)
      expect(destination.reload).to be_occupied
    end

    it "moves a group from one terrain to another" do
      origin = create(:terrain, :occupied, user: user, rest_days: 10)
      destination = create(:terrain, user:)
      previous_occupation = create(:occupation, group:, terrain: origin)
      occupation = described_class.call(user: user, group:, destination:)
      expect(previous_occupation.reload).to be_finished
      expect(origin.reload).to be_resting
      expect(occupation).to be_active
      expect(occupation.terrain).to eq(destination)
      expect(destination.reload).to be_occupied
    end

    it "makes the origin terrain when it does not require rest" do
      origin = create(:terrain, :occupied, user: user, rest_days: 0)
      destination = create(:terrain, user:)
      create(:occupation, group:, terrain: origin)
      described_class.call(user: user, group:, destination:)
      expect(origin.reload).to be_available
    end

    it "allows movement to a resting terrain" do
      destination = create(:terrain, :resting, user:)
      occupation = described_class.call(user: user, group:, destination:)
      expect(occupation.terrain).to eq(destination)
      expect(destination.reload).to be_occupied
    end

    it "does not change the current occupation when the movement is invalid" do
      origin = create(:terrain, :occupied, user: user, rest_days: 10)
      destination = create(:terrain, :occupied, user:)
      current_occupation = create(:occupation, group:, terrain: origin)
      expect {
        described_class.call(user: user, group:, destination:)
      }.to raise_error(Occupations::MovementError)
      expect(current_occupation.reload).to be_active
      expect(origin.reload).to be_occupied
    end

    it "does not move another user's group even when the destination has the same owner" do
      other_group = create(:group)
      destination = create(:terrain, user: other_group.user)

      expect {
        described_class.call(user:, group: other_group, destination:)
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(other_group.occupations).to be_empty
      expect(destination.reload).to be_available
    end

    it "does not change the current occupation when the destination belongs to another user" do
      origin = create(:terrain, :occupied, user:, rest_days: 10)
      destination = create(:terrain)
      occupation = create(:occupation, group:, terrain: origin)

      expect {
        described_class.call(user:, group:, destination:)
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(group.occupations).to contain_exactly(occupation)
      expect(occupation.reload).to be_active
      expect(origin.reload).to be_occupied
      expect(destination.reload).to be_available
    end

    it "does not move a group whose current occupation references another user's terrain" do
      origin = create(:terrain, :occupied)
      destination = create(:terrain, user:)
      occupation = create(:occupation, group:, terrain: origin)

      expect {
        described_class.call(user:, group:, destination:)
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(group.occupations).to contain_exactly(occupation)
      expect(occupation.reload).to be_active
      expect(origin.reload).to be_occupied
      expect(destination.reload).to be_available
    end
  end
end
