require 'rails_helper'

RSpec.describe Terrain, type: :model do
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
end
