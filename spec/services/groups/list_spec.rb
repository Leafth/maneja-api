require 'rails_helper'

RSpec.describe Groups::List, type: :service do
  describe '.call' do
    it "returns only active groups" do
      active_group = create(:group)
      create(:group, :deleted)
      result = described_class.call(page: 1, per_page: 10)
      expect(result.records).to contain_exactly(active_group)
    end

    it "returns a paginated result" do
      create_list(:group, 15)
      result = described_class.call(page: 2, per_page: 10)
      expect(result.records.size).to eq(5)
      expect(result.page).to eq(2)
      expect(result.per_page).to eq(10)
      expect(result.total_items).to eq(15)
      expect(result.total_pages).to eq(2)
    end

    it "paginates the filtered query results" do
      create_list(:group, 15, name: "North Group")
      create_list(:group, 10, name: "South Herd")
      result = described_class.call(filters: { name: "Group" }, page: 1, per_page: 10)
      expect(result.records.size).to eq(10)
      expect(result.total_items).to eq(15)
      expect(result.total_pages).to eq(2)
    end
  end
end
