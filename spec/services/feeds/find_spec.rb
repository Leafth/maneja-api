require 'rails_helper'

RSpec.describe Feeds::Find, type: :service do
  describe '.call' do
    it 'returns an active feed' do
      feed = create(:feed)
      result = described_class.call(id: feed.id)
      expect(result).to eq(feed)
    end

    it 'raises an error when feed deleted' do
      feed = create(:feed, :deleted)
      expect { described_class.call(id: feed.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an error when feed does not exist' do
      expect { described_class.call(id: SecureRandom.uuid) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
