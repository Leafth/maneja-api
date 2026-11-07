require 'rails_helper'

RSpec.describe FeedRequirement, type: :model do
  describe 'validations' do
    it "is valid with valid attributes" do
      requirement = build(:feed_requirement)
      expect(requirement).to be_valid
    end

    it "is invalid without a quantity_per_animal_kg" do
      requirement = build(:feed_requirement, quantity_per_animal_kg: nil)
      expect(requirement).to_not be_valid
    end

    it "is invalid with a zero quantity_per_animal_kg" do
      requirement = build(:feed_requirement, quantity_per_animal_kg: 0)
      expect(requirement).to_not be_valid
    end

    it "is invalid with a negative quantity_per_animal_kg" do
      requirement = build(:feed_requirement, quantity_per_animal_kg: -1.0)
      expect(requirement).to_not be_valid
    end

    it "does not allow the same feed twice for the same group" do
      requirement = create(:feed_requirement)
      duplicate_requirement = build(:feed_requirement, group: requirement.group, feed: requirement.feed)
      expect(duplicate_requirement).to_not be_valid
    end
  end
end
