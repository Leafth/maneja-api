require 'rails_helper'

RSpec.describe Feeds::Deactivate, type: :service do
  describe '.call' do
    it 'deactivates the feed' do
      feed = create(:feed)
      result = described_class.call(id: feed.id)
      expect(result.reload).to be_deleted
    end

    it 'raises an error when the feed is already deleted' do
      feed = create(:feed, :deleted)
      expect {
        described_class.call(id: feed.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an error when the feed does not exist' do
      expect {
        described_class.call(id: SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
