require "rails_helper"

RSpec.describe FeedRequirements::Create, type: :service do
  describe ".call" do
    it "creates a feed requirement for the group" do
      user = create(:user)
      group = create(:group, user: user)
      feed = create(:feed, user: user)

      feed_requirement = described_class.call(
        user:,
        group_id: group.id,
        feed_id: feed.id,
        quantity_per_animal_kg: 5.0
      )

      expect(feed_requirement).to be_persisted
      expect(feed_requirement.group).to eq(group)
      expect(feed_requirement.feed).to eq(feed)
      expect(feed_requirement.quantity_per_animal_kg).to eq(5.0)
    end

    it "does not allow a group from another user" do
      user = create(:user)
      other_user = create(:user)
      group = create(:group, user: other_user)
      feed = create(:feed, user:)

      expect {
        described_class.call(
          user:,
          group_id: group.id,
          feed_id: feed.id,
          quantity_per_animal_kg: 5.0
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not allow a feed from another user" do
      user = create(:user)
      group = create(:group, user:)
      other_user = create(:user)
      feed = create(:feed, user: other_user)

      expect {
        described_class.call(
          user:,
          group_id: group.id,
          feed_id: feed.id,
          quantity_per_animal_kg: 5.0
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
