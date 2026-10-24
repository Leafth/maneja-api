require 'rails_helper'

RSpec.describe Terrains::List, type: :service do
  describe '.call' do
    let(:user) { create(:user) }

    it "returns only active terrains" do
      active_terrain = create(:terrain, user:)
      create(:terrain, :deleted, user:)
      result = described_class.call(user: user, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(active_terrain)
    end

    it "filters terrains by name" do
      matching_terrain = create(:terrain, user: user, name: "North Pasture")
      create(:terrain, user: user, name: "South Pasture")
      result = described_class.call(user: user, filters: { name: "North" }, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(matching_terrain)
    end

    it "filters terrains by rest days range" do
      matching_terrain = create(:terrain, user: user, rest_days: 15)
      create(:terrain, user: user, rest_days: 5)
      create(:terrain, user: user, rest_days: 25)
      result = described_class.call(user: user, filters: { min_rest_days: 10, max_rest_days: 20 }, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(matching_terrain)
    end

    it "filters terrains by status" do
      active_terrain = create(:terrain, user: user, status: :available)
      create(:terrain, user: user, status: :occupied)
      create(:terrain, status: :available)
      result = described_class.call(user: user, filters: { status: "available" }, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(active_terrain)
    end

    it "sorts terrains by rest days" do
      shorter_rest = create(:terrain, user: user, rest_days: 5)
      longer_rest = create(:terrain, user: user, rest_days: 20)
      result = described_class.call(user: user, sort: "rest_days", direction: "desc", page: 1, per_page: 10)
      expect(result.records).to eq([ longer_rest, shorter_rest ])
    end

    it "returns a paginated result" do
      create_list(:terrain, 15, user: user)
      create_list(:terrain, 3)
      result = described_class.call(user: user, page: 2, per_page: 10)
      expect(result.records.size).to eq(5)
      expect(result.page).to eq(2)
      expect(result.per_page).to eq(10)
      expect(result.total_items).to eq(15)
      expect(result.total_pages).to eq(2)
    end
  end
end
