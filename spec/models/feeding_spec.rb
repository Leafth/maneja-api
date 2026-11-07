require 'rails_helper'

RSpec.describe Feeding, type: :model do
  it "is valid with valid attributes" do
    feeding = build(:feeding)
    expect(feeding).to be_valid
  end

  it "is invalid without a quantity" do
    feeding = build(:feeding, quantity: nil)
    expect(feeding).not_to be_valid
  end

  it "is invalid with a zero quantity" do
    feeding = build(:feeding, quantity: 0)
    expect(feeding).not_to be_valid
  end

  it "is invalid with a negative quantity" do
    feeding = build(:feeding, quantity: -1.0)
    expect(feeding).not_to be_valid
  end

  it "is invalid without an occurred_at" do
    feeding = build(:feeding, occurred_at: nil)
    expect(feeding).not_to be_valid
  end
end
