require 'rails_helper'

RSpec.describe Occupations::HistoryByGroup, type: :service do
  describe '.call' do
    it "returns occupations from the group ordered by started_at" do
      group = create(:group)
      older_occupation = create(:occupation, :finished, group:, started_at: 5.days.ago, ended_at: 4.days.ago)
      newer_occupation = create(:occupation, group:, started_at: 1.day.ago)
      create(:occupation)

      result = described_class.call(group:, page: 1, per_page: 10)

      expect(result.records).to eq([ newer_occupation, older_occupation ])
    end

    it "returns paginated results" do
      group = create(:group)
      create_list(:occupation, 25, :finished, group:)

      result = described_class.call(group:, page: 2, per_page: 10)

      expect(result.records.size).to eq(10)
      expect(result.total_items).to eq(25)
      expect(result.total_pages).to eq(3)
    end
  end
end
