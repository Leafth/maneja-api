require 'rails_helper'

RSpec.describe Occupation, type: :model do
  describe 'validations' do
    it "is valid with valid attributes" do
      occupation = build(:occupation)
      expect(occupation).to be_valid
    end

    it "is not valid without a group" do
      occupation = build(:occupation, group: nil)
      expect(occupation).to_not be_valid
      expect(occupation.errors[:group]).to be_present
    end

    it "is not valid without a terrain" do
      occupation = build(:occupation, terrain: nil)
      expect(occupation).to_not be_valid
      expect(occupation.errors[:terrain]).to be_present
    end

    it "is not valid without a started_at" do
      occupation = build(:occupation, started_at: nil)
      expect(occupation).to_not be_valid
      expect(occupation.errors[:started_at]).to be_present
    end

    it "is not valid when ended_at is before started_at" do
      occupation = build(:occupation, started_at: Time.current, ended_at: 1.days.ago)
      expect(occupation).to_not be_valid
      expect(occupation.errors[:ended_at]).to be_present
    end
  end

  describe '.active' do
    it "returns only active occupations" do
      active_occupation = create(:occupation)
       create(:occupation, :finished)
       expect(described_class.active).to contain_exactly(active_occupation)
    end
  end

  describe '.finished' do
    it "returns only finished occupations" do
      finished_occupation = create(:occupation, :finished)
      create(:occupation)
      expect(described_class.finished).to contain_exactly(finished_occupation)
    end
  end

  describe '#active?' do
    it "returns true for active occupations" do
      occupation = build(:occupation)
      expect(occupation.active?).to be true
    end
  end

  describe '#finished?' do
    it "returns true for finished occupations" do
      occupation = build(:occupation, :finished)
      expect(occupation.finished?).to be true
    end
  end
end
