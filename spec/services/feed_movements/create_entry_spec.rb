require 'rails_helper'

RSpec.describe FeedMovements::CreateEntry, type: :service do
  describe '.call' do
    let(:user) { create(:user) }

    it "creates a entry movement" do
      feed = create(:feed, user: user, stock_quantity: 100)
      movement = described_class.call(
        user: user,
        feed_id: feed.id,
        quantity: 50,
        value: 200,
        occurred_on: Date.current
      )
      expect(movement).to be_persisted
      expect(movement).to be_entry
      expect(movement.feed).to eq(feed)
      expect(movement.quantity).to eq(50)
      expect(movement.value).to eq(200)
      expect(movement.occurred_on).to eq(Date.current)
    end

    it "increases the feed stock quantity" do
      feed = create(:feed, user: user, stock_quantity: 100)
      described_class.call(
        user: user,
        feed_id: feed.id,
        quantity: 50,
        value: 200,
        occurred_on: Date.current
      )
      expect(feed.reload.stock_quantity).to eq(150)
    end

    it "does not create a movement when attributes are invalid" do
      feed = create(:feed, user: user, stock_quantity: 100)
      expect {
        described_class.call(
          user: user,
          feed_id: feed.id,
          quantity: -50,
          value: 200,
          occurred_on: Date.current
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(feed.reload.stock_quantity).to eq(100)
      expect(feed.feed_movements).to be_empty
    end

    it "raises an error when the feed is deleted" do
      feed = create(:feed, :deleted, user:)
      expect {
        described_class.call(
          user: user,
          feed_id: feed.id,
          quantity: 50,
          value: 200,
          occurred_on: Date.current
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not change another user's stock or history" do
      feed = create(:feed, stock_quantity: 100)
      existing_movement = create(:feed_movement, feed:)

      expect {
        described_class.call(user:, feed_id: feed.id, quantity: 50, value: 200, occurred_on: Date.current)
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(feed.reload.stock_quantity).to eq(100)
      expect(feed.feed_movements).to contain_exactly(existing_movement)
    end
  end
end
