require 'rails_helper'

RSpec.describe FeedMovement, type: :model do
  describe 'validations' do
    it "is valid with valid attributes" do
      movement = build(:feed_movement)
      expect(movement).to be_valid
    end

    it "is invalid without a movement type" do
      movement = build(:feed_movement, movement_type: nil)
      expect(movement).to_not be_valid
    end

    it "is invalid with an invalid movement type" do
      movement = build(:feed_movement, movement_type: "invalid_type")
      expect(movement).to_not be_valid
    end

    it "is invalid without a quantity" do
      movement = build(:feed_movement, quantity: nil)
      expect(movement).to_not be_valid
    end

    it "is invalid with a zero quantity" do
      movement = build(:feed_movement, quantity: 0)
      expect(movement).to_not be_valid
    end

    it "is invalid with a negative quantity" do
      movement = build(:feed_movement, quantity: -1)
      expect(movement).to_not be_valid
    end

    it "is invalid without an occurred on date" do
      movement = build(:feed_movement, occurred_on: nil)
      expect(movement).to_not be_valid
    end
  end
end
