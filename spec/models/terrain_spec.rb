require 'rails_helper'

RSpec.describe Terrain, type: :model do
  describe 'ownership' do
    it "belongs to a user" do
      user = create(:user)
      terrain = create(:terrain, user:)
      expect(user.terrains).to contain_exactly(terrain)
      expect(terrain.user).to eq(user)
    end

    it "requires a user" do
      terrain = build(:terrain, user: nil)
      expect(terrain).not_to be_valid
      expect(terrain.errors[:user]).to be_present
    end
  end

  it "is valid with valid attributes" do
    expect(build(:terrain)).to be_valid
  end

  it "is not valid without a name" do
    terrain = build(:terrain, name: nil)
    expect(terrain).not_to be_valid
    expect(terrain.errors[:name]).to be_present
  end

  it "is not valid without rest_days" do
    terrain = build(:terrain, rest_days: nil)
    expect(terrain).not_to be_valid
    expect(terrain.errors[:rest_days]).to be_present
  end

  it "is not valid with negative rest_days" do
    terrain = build(:terrain, rest_days: -1)
    expect(terrain).not_to be_valid
    expect(terrain.errors[:rest_days]).to be_present
  end

  it "is not valid with a non-integer rest_days" do
    terrain = build(:terrain, rest_days: 1.5)
    expect(terrain).not_to be_valid
    expect(terrain.errors[:rest_days]).to be_present
  end

  describe '.active' do
    it 'returns only active terrains' do
      active_terrain = create(:terrain)
      create(:terrain, :deleted)
      expect(described_class.active).to contain_exactly(active_terrain)
    end
  end

  describe '.deleted' do
    it 'returns only deleted terrains' do
      deleted_terrain = create(:terrain, :deleted)
      create(:terrain, deleted_at: nil)
      expect(described_class.deleted).to contain_exactly(deleted_terrain)
    end
  end

  describe '#deleted?' do
    it 'returns true if the terrain is deleted' do
      terrain = build(:terrain, :deleted)
      expect(terrain.deleted?).to be true
    end

    it 'returns false if the terrain is not deleted' do
      terrain = build(:terrain)
      expect(terrain.deleted?).to be false
    end
  end

  describe '#soft_delete!' do
    it 'sets the deleted_at timestamp' do
      terrain = create(:terrain)
      expect { terrain.soft_delete! }.not_to change(Terrain, :count)
      expect(terrain.reload.deleted?).to be(true)
    end
  end

  describe '#current_occupation' do
    it 'returns the active occupation' do
      terrain = create(:terrain)
      occupation = create(:occupation, terrain:)
      expect(terrain.current_occupation).to eq(occupation)
    end
  end

  describe '#current_group' do
    it 'returns the group of the active occupation' do
      terrain = create(:terrain)
      group = create(:group)
      create(:occupation, terrain:, group:)
      expect(terrain.current_group).to eq(group)
    end
  end

  describe '#last_occupation' do
    it "returns the most recent finished occupation" do
      terrain = create(:terrain)
      create(:occupation, terrain:, started_at: 4.days.ago, ended_at: 3.days.ago)
      latest_occupation = create(:occupation, terrain:, started_at: 2.days.ago, ended_at: 1.day.ago)
      expect(terrain.last_occupation).to eq(latest_occupation)
    end
  end

  describe '#last_group' do
    it "returns the group of the most recent finished occupation" do
      terrain = create(:terrain)
      group = create(:group)
      create(:occupation, terrain:, group:, started_at: 2.days.ago, ended_at: 1.days.ago)
      expect(terrain.last_group).to eq(group)
    end
  end

  describe '#remaining_rest_days' do
    it "returns the remaining rest days" do
      terrain = create(:terrain, :resting, rest_days: 15)
      create(:occupation, terrain:, started_at: 6.days.ago, ended_at: 5.days.ago)
      expect(terrain.remaining_rest_days).to eq(10)
    end

    it "returns 0 if the rest period has already passed" do
      terrain = create(:terrain, :resting, rest_days: 5)
      create(:occupation, terrain:, started_at: 11.days.ago, ended_at: 10.days.ago)
      expect(terrain.remaining_rest_days).to eq(0)
    end

    it "returns 0 if the terrain is not resting" do
      terrain = create(:terrain)
      expect(terrain.remaining_rest_days).to eq(0)
    end
  end

  describe '#days_free' do
    it "returns the number of days since the last occupation ended" do
      terrain = create(:terrain)
      create(:occupation, terrain:, started_at: 6.days.ago, ended_at: 5.days.ago)
      expect(terrain.days_free).to eq(5)
    end

    it "returns the number of days since creation if there are no occupations" do
      terrain = create(:terrain, created_at: 5.days.ago)
      expect(terrain.days_free).to eq(5)
    end

    it "returns 0 if the terrain is not available" do
      terrain = create(:terrain, :resting)
      expect(terrain.days_free).to eq(0)
    end
  end
end
