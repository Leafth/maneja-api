require 'rails_helper'


RSpec.describe Groups::Delete, type: :service do
  describe '.call' do
    it "soft deletes the group" do
      group = create(:group)
      result = described_class.call(id: group.id)
      expect(result).to be_deleted
      expect(result.deleted_at).to be_present
    end

    it "keeps the group persisted" do
      group = create(:group)
      expect { described_class.call(id: group.id) }.not_to change(Group, :count)
    end

    it "removes the group from the active scope" do
      group = create(:group)
      described_class.call(id: group.id)
      expect(Group.active).not_to include(group)
    end

    it "raises an error if the group is already deleted" do
      group = create(:group, :deleted)
      expect {
        described_class.call(id: group.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error if the group is not found" do
      expect {
        described_class.call(id: 999)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
