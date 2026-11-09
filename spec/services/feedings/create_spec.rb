require "rails_helper"

RSpec.describe Feedings::Create, type: :service do
  describe ".call" do
    it "creates a feeding and a feed movement exit" do
      user = create(:user)
      group = create(:group, user:)
      feed = create(:feed, user:, stock_quantity: 100.0)
      occurred_at = Time.zone.local(2026, 11, 7, 18, 30)
      feeding = nil

      expect {
        feeding = described_class.call(
          user:,
          group_id: group.id,
          feed_id: feed.id,
          quantity: 25.0,
          occurred_at:
        )
      }.to change(Feeding, :count).by(1).and change(FeedMovement, :count).by(1)

      expect(feeding.group).to eq(group)
      expect(feeding.feed).to eq(feed)
      expect(feeding.quantity).to eq(25.0)
      expect(feeding.occurred_at).to eq(occurred_at)

      feed_movement = FeedMovement.last
      expect(feed_movement.feed).to eq(feed)
      expect(feed_movement).to be_exit
      expect(feed_movement.quantity).to eq(25.0)
      expect(feed_movement.occurred_on).to eq(occurred_at.to_date)

      expect(feed_movement.reason).to eq(I18n.t("feed_movements.reasons.feeding", group_name: group.name))
      expect(feed.reload.stock_quantity).to eq(75.0)
    end

    it "raises not found when group belongs to another user" do
      user = create(:user)
      other_user = create(:user)
      group = create(:group, user: other_user)
      feed = create(:feed, user:, stock_quantity: 100.0)

      expect {
        described_class.call(
          user:,
          group_id: group.id,
          feed_id: feed.id,
          quantity: 25.0,
          occurred_at: Time.current
        )
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(Feeding.count).to eq(0)
      expect(FeedMovement.count).to eq(0)
    end

    it "raises not found when feed belongs to another user" do
      user = create(:user)
      other_user = create(:user)
      group = create(:group, user:)
      feed = create(:feed, user: other_user, stock_quantity: 100.0)

      expect {
        described_class.call(
          user:,
          group_id: group.id,
          feed_id: feed.id,
          quantity: 25.0,
          occurred_at: Time.current
        )
      }.to raise_error(ActiveRecord::RecordNotFound)

      expect(Feeding.count).to eq(0)
      expect(FeedMovement.count).to eq(0)
    end

    it "rolls back the feeding when stock quantity is insufficient" do
      user = create(:user)
      group = create(:group, user:)
      feed = create(:feed, user:, stock_quantity: 10.0)

      expect {
        expect {
          described_class.call(
            user:,
            group_id: group.id,
            feed_id: feed.id,
            quantity: 25.0,
            occurred_at: Time.current
          )
        }.to raise_error(ActiveRecord::RecordInvalid)
      }

      expect(Feeding.count).to eq(0)
      expect(FeedMovement.count).to eq(0)
      expect(feed.reload.stock_quantity).to eq(10.0)
    end
  end
end
