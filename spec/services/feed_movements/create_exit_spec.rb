require 'rails_helper'

RSpec.describe FeedMovements::CreateExit, type: :service do
  describe '.call' do
    it "creates an exit movement" do
      feed = create(:feed, stock_quantity: 100)
      movement = described_class.call(
        feed_id: feed.id,
        quantity: 50,
        reason: "Sold",
        occurred_on: Date.current
      )
      expect(movement).to be_persisted
      expect(movement).to be_exit
      expect(movement.feed).to eq(feed)
      expect(movement.quantity).to eq(50)
      expect(movement.reason).to eq("Sold")
      expect(movement.occurred_on).to eq(Date.current)
    end

    it "decreases the feed stock quantity" do
      feed = create(:feed, stock_quantity: 100)
      described_class.call(
        feed_id: feed.id,
        quantity: 50,
        reason: "Sold",
        occurred_on: Date.current
      )
      expect(feed.reload.stock_quantity).to eq(50)
    end

    it "allows removing the entire available stock" do
      feed = create(:feed, stock_quantity: 100)
      described_class.call(
        feed_id: feed.id,
        quantity: 100,
        reason: "Sold",
        occurred_on: Date.current
      )
      expect(feed.reload.stock_quantity).to eq(0)
    end

    it "does not allow exit movement when stock is insufficient" do
      feed = create(:feed, stock_quantity: 30)
      expect {
        described_class.call(
          feed_id: feed.id,
          quantity: 50,
          reason: "Sold",
          occurred_on: Date.current
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(feed.reload.stock_quantity).to eq(30)
      expect(feed.feed_movements).to be_empty
    end

    it "does not create a movement when attributes are invalid" do
      feed = create(:feed, stock_quantity: 100)
      expect {
        described_class.call(
          feed_id: feed.id,
          quantity: -50,
          reason: "Sold",
          occurred_on: Date.current
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(feed.reload.stock_quantity).to eq(100)
      expect(feed.feed_movements).to be_empty
    end

    it "raises an error when the feed is deleted" do
      feed = create(:feed, :deleted)
      expect {
        described_class.call(
          feed_id: feed.id,
          quantity: 50,
          reason: "Sold",
          occurred_on: Date.current
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
