require 'rails_helper'

RSpec.describe Feeds::List, type: :service do
  describe '.call' do
    let(:user) { create(:user) }

    it "returns only active feeds" do
      active_feed = create(:feed, user:)
      create(:feed, :deleted, user:)
      result = described_class.call(user: user, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(active_feed)
    end

    it "filters feeds by name" do
      matching_feed = create(:feed, user: user, name: "Premium Feed")
      create(:feed, user: user, name: "Basic Feed")
      result = described_class.call(user: user, filters: { name: "Premium" }, page: 1, per_page: 10)
      expect(result.records).to contain_exactly(matching_feed)
    end

    it "sorts feeds by stock quantity" do
      low_stock_feed = create(:feed, user: user, stock_quantity: 5)
      high_stock_feed = create(:feed, user: user, stock_quantity: 20)
      result = described_class.call(user: user, sort: "stock_quantity", direction: "desc", page: 1, per_page: 10)
      expect(result.records).to eq([ high_stock_feed, low_stock_feed ])
    end

    it "returns a paginated result" do
      create_list(:feed, 15, user: user)
      result = described_class.call(user: user, page: 2, per_page: 10)
      expect(result.records.size).to eq(5)
      expect(result.page).to eq(2)
      expect(result.per_page).to eq(10)
      expect(result.total_items).to eq(15)
      expect(result.total_pages).to eq(2)
    end

    it "paginates the filtered query results" do
      create_list(:feed, 15, user: user, name: "Premium Feed")
      create_list(:feed, 10, user: user, name: "Basic Feed")
      create_list(:feed, 3, name: "Premium Feed")
      result = described_class.call(user: user, filters: { name: "Premium" }, page: 1, per_page: 10)
      expect(result.records.size).to eq(10)
      expect(result.total_items).to eq(15)
      expect(result.total_pages).to eq(2)
    end

    it "filters the user's feeds by stock quantity range" do
      matching_feed = create(:feed, user:, stock_quantity: 15)
      create(:feed, user:, stock_quantity: 5)
      create(:feed, user:, stock_quantity: 25)
      create(:feed, stock_quantity: 15)

      result = described_class.call(user:, filters: { min_stock_quantity: 10, max_stock_quantity: 20 }, page: 1, per_page: 10)

      expect(result.records).to contain_exactly(matching_feed)
    end
  end
end
