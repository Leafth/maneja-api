require "rails_helper"

RSpec.describe FeedRequirements::Update, type: :service do
  describe ".call" do
    it "updates the feed requirement" do
      user = create(:user)
      group = create(:group, user:)
      old_feed = create(:feed, user:)
      new_feed = create(:feed, user:)
      feed_requirement = create(:feed_requirement, group:, feed: old_feed, quantity_per_animal_kg: 5.0)
      result = described_class.call(
        user:,
        group_id: group.id,
        id: feed_requirement.id,
        feed_id: new_feed.id,
        quantity_per_animal_kg: 4.2
      )
      expect(result).to have_attributes(feed: new_feed, quantity_per_animal_kg: 4.2)
    end

    it "persists the changes" do
      user = create(:user)
      group = create(:group, user:)
      old_feed = create(:feed, user:)
      new_feed = create(:feed, user:)
      feed_requirement = create(:feed_requirement, group:, feed: old_feed, quantity_per_animal_kg: 5.0)
      described_class.call(
        user:,
        group_id: group.id,
        id: feed_requirement.id,
        feed_id: new_feed.id,
        quantity_per_animal_kg: 4.2
      )
      expect(feed_requirement.reload).to have_attributes(feed: new_feed, quantity_per_animal_kg: 4.2)
    end

    it "does not allow a feed from another user" do
      user = create(:user)
      other_user = create(:user)
      group = create(:group, user:)
      feed_requirement = create(:feed_requirement, group:, feed: create(:feed, user:))
      other_feed = create(:feed, user: other_user)
      expect {
        described_class.call(
          user:,
          group_id: group.id,
          id: feed_requirement.id,
          feed_id: other_feed.id,
          quantity_per_animal_kg: 4.2
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not allow access through a group from another user" do
      user = create(:user)
      other_user = create(:user)
      group = create(:group, user: other_user)
      feed = create(:feed, user: other_user)
      feed_requirement = create(:feed_requirement, group:, feed:)
      expect {
        described_class.call(
          user:,
          group_id: group.id,
          id: feed_requirement.id,
          feed_id: feed.id,
          quantity_per_animal_kg: 4.2
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not find a requirement from another group" do
      user = create(:user)
      group = create(:group, user:)
      other_group = create(:group, user:)
      feed = create(:feed, user:)
      feed_requirement = create(:feed_requirement, group: other_group, feed:)
      expect {
        described_class.call(
          user:,
          group_id: group.id,
          id: feed_requirement.id,
          feed_id: feed.id,
          quantity_per_animal_kg: 4.2
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
