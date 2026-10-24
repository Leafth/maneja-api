require 'rails_helper'

RSpec.describe Groups::Deactivate, type: :service do
  describe '.call' do
    let(:user) { create(:user) }

    it "deactivates the group" do
      group = create(:group, user:)
      result = described_class.call(user: user, id: group.id)
      expect(result.reload).to be_deleted
    end

    it "closes the current occupation when the group is occupying a terrain" do
      group = create(:group, user:)
      terrain = create(:terrain, :occupied, user:)
      occupation = create(:occupation, group:, terrain:)
      described_class.call(user: user, id: group.id)
      expect(occupation.reload).to be_finished
    end

    it "starts the terrain rest when the group is removed" do
      group = create(:group, user:)
      terrain = create(:terrain, :occupied, user: user, rest_days: 10)
      create(:occupation, group:, terrain:)
      described_class.call(user: user, id: group.id)
      expect(terrain.reload).to be_resting
    end

    it "makes the terrain available when rest_days is 0" do
      group = create(:group, user:)
      terrain = create(:terrain, :occupied, user: user, rest_days: 0)
      create(:occupation, group:, terrain:)
      described_class.call(user: user, id: group.id)
      expect(terrain.reload).to be_available
    end

    it "raises an error when the group does not exist" do
      expect {
        described_class.call(user: user, id: SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not change another user's group or its occupation and terrain" do
      group = create(:group)
      terrain = create(:terrain, :occupied, user: group.user, rest_days: 10)
      occupation = create(:occupation, group:, terrain:)

      expect {
        described_class.call(user:, id: group.id)
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(group.reload).not_to be_deleted
      expect(occupation.reload).to be_active
      expect(terrain.reload).to be_occupied
    end

    it "does not deactivate a group whose occupation references another user's terrain" do
      group = create(:group, user:)
      terrain = create(:terrain, :occupied, rest_days: 10)
      occupation = create(:occupation, group:, terrain:)

      expect {
        described_class.call(user:, id: group.id)
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(group.reload).not_to be_deleted
      expect(occupation.reload).to be_active
      expect(terrain.reload).to be_occupied
    end
  end
end
