require 'rails_helper'

RSpec.describe Occupations::HistoryByTerrain, type: :service do
  describe ".call" do
    it "returns occupations from the terrain ordered by started_at" do
      terrain = create(:terrain)
      older_occupation = create(:occupation, :finished, terrain:, started_at: 5.days.ago, ended_at: 4.days.ago)
      newer_occupation = create(:occupation, terrain:, started_at: 1.day.ago)
      create(:occupation)

      result = described_class.call(terrain:, page: 1, per_page: 10)

      expect(result.records).to eq([ newer_occupation, older_occupation ])
    end

    it "returns paginated results" do
      terrain = create(:terrain)
      create_list(:occupation, 25, :finished, terrain:)

      result = described_class.call(terrain:, page: 2, per_page: 10)

      expect(result.records.size).to eq(10)
      expect(result.total_items).to eq(25)
      expect(result.total_pages).to eq(3)
    end
  end
end
