require 'rails_helper'

RSpec.describe Groups::Deactivate, type: :service do
  describe '.call' do
    it "deactivates the group" do
      group = create(:group)
      result = described_class.call(id: group.id)
      expect(result.reload).to be_deleted
    end

    it "closes the current occupation when the group is occupying a terrain" do
      group = create(:group)
      terrain = create(:terrain, :occupied)
      occupation = create(:occupation, group:, terrain:)
      described_class.call(id: group.id)
      expect(occupation.reload).to be_finished
    end

    it "starts the terrain rest when the group is removed" do
      group = create(:group)
      terrain = create(:terrain, :occupied, rest_days: 10)
      create(:occupation, group:, terrain:)
      described_class.call(id: group.id)
      expect(terrain.reload).to be_resting
    end

    it "makes the terrain available when rest_days is 0" do
      group = create(:group)
      terrain = create(:terrain, :occupied, rest_days: 0)
      create(:occupation, group:, terrain:)
      described_class.call(id: group.id)
      expect(terrain.reload).to be_available
    end

    it "raises an error when the group does not exist" do
      expect {
        described_class.call(id: SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
