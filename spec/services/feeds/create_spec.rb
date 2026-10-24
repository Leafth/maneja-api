require 'rails_helper'

RSpec.describe Feeds::Create, type: :service do
  describe '.call' do
    let(:user) { create(:user) }
    it "creates a feed with initial stock quantity" do
      feed = described_class.call(user: user, name: "Feed A", initial_stock_quantity: 100)
      expect(feed).to be_persisted
      expect(feed.user).to eq(user)
      expect(feed.name).to eq("Feed A")
      expect(feed.stock_quantity).to eq(100)
    end

    it "raises an error if the feed cannot be created" do
      expect {
        described_class.call(user: user, name: nil, initial_stock_quantity: 100)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
