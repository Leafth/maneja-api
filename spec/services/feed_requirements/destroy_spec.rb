require "rails_helper"

describe FeedRequirements::Destroy, type: :service do
  describe ".call" do
    it "destroys the feed requirement" do
      user = create(:user)
      group = create(:group, user:)
      feed_requirement = create(:feed_requirement, group:, feed: create(:feed, user:))
      result = described_class.call(user:, group_id: group.id, id: feed_requirement.id)
      expect(result).to eq(feed_requirement)
      expect { feed_requirement.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not allow access through a group from another user" do
      user = create(:user)
      other_user = create(:user)
      group = create(:group, user: other_user)
      feed_requirement = create(:feed_requirement, group:, feed: create(:feed, user: other_user))
      expect {
        described_class.call(user:, group_id: group.id, id: feed_requirement.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not find a feed requirement from another group" do
      user = create(:user)
      group = create(:group, user:)
      other_group = create(:group, user:)
      feed_requirement = create(:feed_requirement, group: other_group, feed: create(:feed, user:))
      expect {
        described_class.call(user:, group_id: group.id, id: feed_requirement.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
