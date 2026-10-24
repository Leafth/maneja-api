require 'rails_helper'

RSpec.describe Feeds::Update, type: :service do
  describe '.call' do
    it 'updates the feed name' do
      feed = create(:feed, name: "Old Name")
      result = described_class.call(id: feed.id, name: "New Name")
      expect(result.name).to eq("New Name")
    end

    it "persists the changes" do
      feed = create(:feed, name: "Old Name")
      described_class.call(id: feed.id, name: "New Name")
      expect(feed.reload.name).to eq("New Name")
    end

    it "raises an error if the name is invalid" do
      feed = create(:feed)
      expect {
        described_class.call(id: feed.id, name: "")
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the feed is deleted' do
      feed = create(:feed, :deleted)
      expect {
        described_class.call(id: feed.id, name: "New Name")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an error when the feed does not exist' do
      expect {
        described_class.call(id: SecureRandom.uuid, name: "New Name")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
