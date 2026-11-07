require "rails_helper"

RSpec.describe FeedRequirements::List, type: :service do
  describe ".call" do
    it "returns feed requirements for the group" do
      user = create(:user)
      group = create(:group, user:)
      other_group = create(:group, user:)

      feed_requirement = create(:feed_requirement, group:, feed: create(:feed, user:))
      create(:feed_requirement, group: other_group, feed: create(:feed, user:))

      result = described_class.call(user:, group_id: group.id)

      expect(result).to contain_exactly(feed_requirement)
    end

    it "returns an empty collection if the group has no feed requirements" do
      user = create(:user)
      group = create(:group, user:)

      result = described_class.call(user:, group_id: group.id)

      expect(result).to be_empty
    end

    it "does not allow a group from another user" do
      user = create(:user)
      other_user = create(:user)
      group = create(:group, user: other_user)

      expect {
        described_class.call(user:, group_id: group.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not allow access to an inactive group" do
      user = create(:user)
      group = create(:group, :deleted, user:)

      expect {
        described_class.call(user:, group_id: group.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
