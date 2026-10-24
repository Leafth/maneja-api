require 'rails_helper'

RSpec.describe Feeds::Find, type: :service do
  describe '.call' do
    let(:user) { create(:user) }

    it 'returns an active feed' do
      feed = create(:feed, user:)
      result = described_class.call(user: user, id: feed.id)
      expect(result).to eq(feed)
    end

    it 'raises an error when feed deleted' do
      feed = create(:feed, :deleted, user:)
      expect { described_class.call(user: user, id: feed.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an error when feed does not exist' do
      expect { described_class.call(user: user, id: SecureRandom.uuid) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error when the feed belongs to another user" do
      feed = create(:feed)

      expect { described_class.call(user:, id: feed.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
