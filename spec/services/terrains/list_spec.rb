require 'rails_helper'

RSpec.describe Terrains::List, type: :service do
  describe '.call' do
    it "returns only active terrains" do
      active_terrain = create(:terrain)
      create(:terrain, :deleted)
      result = described_class.call(page: 1, per_page: 10)
      expect(result.records).to contain_exactly(active_terrain)
    end

    it "filters terrains by name" do
      matching_terrain = create(:terrain, name: "North Pasture")
      create(:terrain, name: "South Pasture")
      result = described_class.call(filters: { name: "North" }, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(matching_terrain)
    end

    it "filters terrains by rest days range" do
      matching_terrain = create(:terrain, rest_days: 15)
      create(:terrain, rest_days: 5)
      create(:terrain, rest_days: 25)
      result = described_class.call(filters: { min_rest_days: 10, max_rest_days: 20 }, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(matching_terrain)
    end

    it "filters terrains by status" do
      active_terrain = create(:terrain, status: :available)
      create(:terrain, status: :occupied)
      result = described_class.call(filters: { status: "available" }, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(active_terrain)
    end

    it "sorts terrains by rest days" do
      shorter_rest = create(:terrain, rest_days: 5)
      longer_rest = create(:terrain, rest_days: 20)
      result = described_class.call(sort: "rest_days", direction: "desc", page: 1, per_page: 10)
      expect(result.records).to eq([ longer_rest, shorter_rest ])
    end

    it "returns a paginated result" do
      create_list(:terrain, 15)
      result = described_class.call(page: 2, per_page: 10)
      expect(result.records.size).to eq(5)
      expect(result.page).to eq(2)
      expect(result.per_page).to eq(10)
      expect(result.total_items).to eq(15)
      expect(result.total_pages).to eq(2)
    end
  end
end
