require 'rails_helper'

RSpec.describe Feeds::Create, type: :service do
  describe '.call' do
    it "creates a feed with initial stock quantity" do
      feed = described_class.call(name: "Feed A", initial_stock_quantity: 100)
      expect(feed).to be_persisted
      expect(feed.name).to eq("Feed A")
      expect(feed.stock_quantity).to eq(100)
    end

    it "raises an error if the feed cannot be created" do
      expect {
        described_class.call(name: nil, initial_stock_quantity: 100)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
