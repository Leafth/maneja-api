require 'rails_helper'

RSpec.describe Feeds::Deactivate, type: :service do
  describe '.call' do
    let(:user) { create(:user) }

    it 'deactivates the feed' do
      feed = create(:feed, user:)
      result = described_class.call(user: user, id: feed.id)
      expect(result.reload).to be_deleted
    end

    it 'raises an error when the feed is already deleted' do
      feed = create(:feed, :deleted, user:)
      expect {
        described_class.call(user: user, id: feed.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an error when the feed does not exist' do
      expect {
        described_class.call(user: user, id: SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not change another user's feed or its history" do
      feed = create(:feed, stock_quantity: 100)
      movement = create(:feed_movement, feed:)

      expect {
        described_class.call(user:, id: feed.id)
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(feed.reload).not_to be_deleted
      expect(feed.stock_quantity).to eq(100)
      expect(feed.feed_movements).to contain_exactly(movement)
    end
  end
end
