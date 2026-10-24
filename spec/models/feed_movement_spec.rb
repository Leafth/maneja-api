require 'rails_helper'

RSpec.describe FeedMovement, type: :model do
  describe 'validations' do
    it "is valid with valid entry attributes" do
      movement = build(:feed_movement, :entry)
      expect(movement).to be_valid
    end

    it "is valid with valid exit attributes" do
      movement = build(:feed_movement, :exit)
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

    context "when movement type is entry" do
      it "is invalid without a value" do
        movement = build(:feed_movement, :entry, value: nil)
        expect(movement).to_not be_valid
      end

      it "is invalid with a negative value" do
        movement = build(:feed_movement, :entry, value: -1)
        expect(movement).to_not be_valid
      end
    end

    context "when movement type is exit" do
      it "is invalid without a reason" do
        movement = build(:feed_movement, :exit, reason: nil)
        expect(movement).to_not be_valid
      end
    end
  end
end
