require 'rails_helper'

RSpec.describe Feed, type: :model do
  describe 'ownership' do
    it "belongs to a user" do
      user = create(:user)
      feed = create(:feed, user:)
      expect(user.feeds).to contain_exactly(feed)
      expect(feed.user).to eq(user)
    end

    it "requires a user" do
      feed = build(:feed, user: nil)
      expect(feed).not_to be_valid
      expect(feed.errors[:user]).to be_present
    end
  end

  describe 'validations' do
    it "is valid with valid attributes" do
      feed = build(:feed)
      expect(feed).to be_valid
    end

    it "is not valid without a name" do
      feed = build(:feed, name: nil)
      expect(feed).not_to be_valid
    end

    it "is not valid without a stock_quantity" do
      feed = build(:feed, stock_quantity: nil)
      expect(feed).not_to be_valid
    end

    it "is not valid with a negative stock_quantity" do
      feed = build(:feed, stock_quantity: -1.0)
      expect(feed).not_to be_valid
    end
  end

  describe '.active' do
    it "returns only active feeds" do
      active_feed = create(:feed)
      create(:feed, :deleted)
      expect(described_class.active).to contain_exactly(active_feed)
    end
  end

  describe '.deleted' do
    it "returns only deleted feeds" do
      create(:feed)
      deleted_feed = create(:feed, :deleted)
      expect(described_class.deleted).to contain_exactly(deleted_feed)
    end
  end

  describe '#deleted?' do
    it "returns true if the feed is deleted" do
      feed = build(:feed, :deleted)
      expect(feed.deleted?).to be true
    end

    it "returns false if the feed is not deleted" do
      feed = build(:feed)
      expect(feed.deleted?).to be false
    end
  end

  describe '#soft_delete!' do
    it "marks the feed as deleted" do
      feed = create(:feed)
      feed.soft_delete!
      expect(feed.deleted?).to be true
    end
  end
end
