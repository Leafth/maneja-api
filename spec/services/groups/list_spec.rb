require 'rails_helper'

RSpec.describe Groups::List, type: :service do
  describe '.call' do
    let(:user) { create(:user) }

    it "returns only active groups" do
      active_group = create(:group, user:)
      create(:group, :deleted, user:)
      result = described_class.call(user: user, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(active_group)
    end

    it "filters groups by name" do
      matching_group = create(:group, user: user, name: "North Herd")
      create(:group, user: user, name: "South Herd")
      result = described_class.call(user: user, filters: { name: "North" }, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(matching_group)
    end

    it "filters groups by animal count range" do
      matching_group = create(:group, user: user, animal_count: 15)
      create(:group, user: user, animal_count: 5)
      create(:group, user: user, animal_count: 25)
      result = described_class.call(user: user, filters: { min_animal_count: 10, max_animal_count: 20 }, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(matching_group)
    end

    it "sorts groups by animal count" do
      small_group = create(:group, user: user, animal_count: 5)
      large_group = create(:group, user: user, animal_count: 20)
      result = described_class.call(user: user, sort: "animal_count", direction: "desc", page: 1, per_page: 10)
      expect(result.records).to eq([ large_group, small_group ])
    end

    it "returns a paginated result" do
      create_list(:group, 15, user: user)
      result = described_class.call(user: user, page: 2, per_page: 10)
      expect(result.records.size).to eq(5)
      expect(result.page).to eq(2)
      expect(result.per_page).to eq(10)
      expect(result.total_items).to eq(15)
      expect(result.total_pages).to eq(2)
    end

    it "paginates the filtered query results" do
      create_list(:group, 15, user: user, name: "North Group")
      create_list(:group, 10, user: user, name: "South Herd")
      create_list(:group, 3, name: "North Group")
      result = described_class.call(user: user, filters: { name: "Group" }, page: 1, per_page: 10)
      expect(result.records.size).to eq(10)
      expect(result.total_items).to eq(15)
      expect(result.total_pages).to eq(2)
    end
  end
end
