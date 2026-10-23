require 'rails_helper'

RSpec.describe Terrains::ReleaseResting, type: :service do
  describe '.call' do
    it "releases terrains that have completed their resting period" do
      terrain = create(:terrain, :resting, rest_days: 5)
      create(:occupation, :finished, terrain:, started_at: 10.days.ago, ended_at: 6.days.ago)
      described_class.call
      expect(terrain.reload).to be_available
    end

    it "keeps terrains resting when the rest period is not completed" do
      terrain = create(:terrain, :resting, rest_days: 10)
      create(:occupation, :finished, terrain:, started_at: 5.days.ago, ended_at: 3.days.ago)
      described_class.call
      expect(terrain.reload).to be_resting
    end
  end
end
