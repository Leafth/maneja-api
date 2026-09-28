require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validations' do
    it "is valid with valid attributes" do
      group = build(:group)
      expect(group).to be_valid
    end

    it "is not valid without a name" do
      group = build(:group, name: nil)
      expect(group).not_to be_valid
      expect(group.errors[:name]).to be_present
    end

    it "is not valid without an animal_count" do
      group = build(:group, animal_count: nil)
      expect(group).not_to be_valid
      expect(group.errors[:animal_count]).to be_present
    end

    it "is not valid with an animal_count that is negative" do
      group = build(:group, animal_count: -1)
      expect(group).not_to be_valid
      expect(group.errors[:animal_count]).to be_present
    end

    it "is not valid with an animal_count that is not an integer" do
      group = build(:group, animal_count: 1.5)
      expect(group).not_to be_valid
      expect(group.errors[:animal_count]).to be_present
    end
  end

  describe '.active' do
    it "returns only active groups" do
      active_group = create(:group)
      create(:group, :deleted)
      expect(described_class.active).to contain_exactly(active_group)
    end
  end

  describe '.deleted' do
    it "returns only deleted groups" do
      create(:group)
      deleted_group = create(:group, :deleted)
      expect(described_class.deleted).to contain_exactly(deleted_group)
    end
  end

  describe '#deleted?' do
    it "returns true if the group is deleted" do
      group = build(:group, :deleted)
      expect(group.deleted?).to be true
    end

    it "returns false if the group is not deleted" do
      group = build(:group)
      expect(group.deleted?).to be false
    end
  end

  describe '#soft_delete!' do
    it "marks the group as deleted without removing it from the database" do
      group = create(:group)
      expect { group.soft_delete! }.not_to change(Group, :count)
      expect(group.reload.deleted?).to be true
    end
  end
end
