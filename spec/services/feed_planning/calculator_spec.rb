require "rails_helper"

RSpec.describe FeedPlanning::Calculator do
  describe ".call" do
    it "calculates the required quantity for a group" do
      user = create(:user)
      group = create(:group, user:, animal_count: 10)
      feed = create(:feed, user:, stock_quantity: 100)
      create(:feed_requirement, group:, feed:, quantity_per_animal_kg: 2)
      result = described_class.call(groups: [ group ], days: 5)

      expect(result.size).to eq(1)
      expect(result).to eq([
        {
          feed_id: feed.id,
          feed_name: feed.name,
          stock_quantity: 100,
          required_quantity: 100,
          missing_quantity: 0,
          sufficient: true
        }
      ])
    end

    it "aggregates the required quantity for multiple groups with the same feed" do
      user = create(:user)
      group_one = create(:group, user:, animal_count: 20)
      group_two = create(:group, user:, animal_count: 10)
      feed = create(:feed, user:, stock_quantity: 500)
      create(:feed_requirement, group: group_one, feed:, quantity_per_animal_kg: 2)
      create(:feed_requirement, group: group_two, feed:, quantity_per_animal_kg: 3)
      result = described_class.call(groups: [ group_one, group_two ], days: 5)

      expect(result.size).to eq(1)
      expect(result).to eq([
        {
          feed_id: feed.id,
          feed_name: feed.name,
          stock_quantity: 500,
          required_quantity: 350,
          missing_quantity: 0,
          sufficient: true
        }
      ])
    end

    it "keeps the diferent feeds separate" do
      user = create(:user)
      group = create(:group, user:, animal_count: 10)
      feed_one = create(:feed, user:, stock_quantity: 100)
      feed_two = create(:feed, user:, stock_quantity: 50)
      create(:feed_requirement, group:, feed: feed_one, quantity_per_animal_kg: 2)
      create(:feed_requirement, group:, feed: feed_two, quantity_per_animal_kg: 3)
      result = described_class.call(groups: [ group ], days: 5)

      expect(result.size).to eq(2)
      expect(result).to eq([
        {
          feed_id: feed_one.id,
          feed_name: feed_one.name,
          stock_quantity: 100,
          required_quantity: 100,
          missing_quantity: 0,
          sufficient: true
        },
        {
          feed_id: feed_two.id,
          feed_name: feed_two.name,
          stock_quantity: 50,
          required_quantity: 150,
          missing_quantity: 100,
          sufficient: false
        }
      ])
    end
  end
end
