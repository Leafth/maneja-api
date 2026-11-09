require "rails_helper"

RSpec.describe Feedings::History, type: :service do
  describe ".call" do
    it "returns paginated feedings for the specified group" do
      user = create(:user)
      group = create(:group, user:)
      feed = create(:feed, user:)
      older = create(:feeding, group:, feed:, occurred_at: 2.days.ago)
      newer = create(:feeding, group:, feed:, occurred_at: 1.day.ago)
      result = described_class.call(user:, group_id: group.id, page: 1, per_page: 10)
      expect(result.records).to include(newer, older)
    end

    it "does not return feedings for other groups" do
      user = create(:user)
      group = create(:group, user:)
      other_group = create(:group, user:)
      feed = create(:feed, user:)
      feeding = create(:feeding, group:, feed:)
      create(:feeding, group: other_group, feed:)
      result = described_class.call(user:, group_id: group.id, page: 1, per_page: 10)
      expect(result.records).to eq([ feeding ])
    end

    it "raises not found if the group does not belong to the user" do
      user = create(:user)
      other_user = create(:user)
      group = create(:group, user: other_user)
      expect { described_class.call(user:, group_id: group.id, page: 1, per_page: 10) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
