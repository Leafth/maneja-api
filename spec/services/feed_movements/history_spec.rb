require 'rails_helper'

RSpec.describe FeedMovements::History do
  describe '.call' do
    let(:user) { create(:user) }

    it "returns the history of feed movements for a given feed" do
      feed = create(:feed, user:)
      other_feed = create(:feed, user:)
      entry_movement = create(:feed_movement, :entry, feed:, quantity: 50, value: 200, occurred_on: Date.current - 1.day)
      exit_movement = create(:feed_movement, :exit, feed:, quantity: 30, reason: "Sold", occurred_on: Date.current)
      create(:feed_movement, :entry, feed: other_feed, quantity: 20, value: 100, occurred_on: Date.current)
      result = described_class.call(user: user, feed_id: feed.id, page: 1, per_page: 10)
      expect(result.records).to eq([ exit_movement, entry_movement ])
    end

    it "raises an error when the feed does not exist" do
      expect { described_class.call(user: user, feed_id: SecureRandom.uuid, page: 1, per_page: 10) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error when the feed is deleted" do
      feed = create(:feed, :deleted, user:)
      expect { described_class.call(user: user, feed_id: feed.id, page: 1, per_page: 10) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
