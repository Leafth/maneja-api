require "rails_helper"

RSpec.describe FeedPlanning::Calculator do
  describe ".call" do
    it "calculates the required quantity for a group" do
      user = create(:user)
      group = create(:group, user:, animal_count: 10)
      feed = create(:feed, user:, stock_quantity: 100)
      create(:feed_requirement, group:, feed:, quantity_per_animal_kg: 2)
      snapshot = FeedConsumption::Snapshot.call(user:)
      result = described_class.call(groups: [ group ], snapshot:, days: 5)

      expect(result.size).to eq(1)
      expect(result).to eq([
        {
          feed_id: feed.id,
          feed_name: feed.name,
          stock_quantity: 100,
          required_quantity: 100,
          global_required_quantity: 100,
          status: {
            state: "sufficient",
            remaining_quantity: 0
          }
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
      snapshot = FeedConsumption::Snapshot.call(user:)
      result = described_class.call(groups: [ group_one, group_two ], snapshot:, days: 5)

      expect(result.size).to eq(1)
      expect(result).to eq([
        {
          feed_id: feed.id,
          feed_name: feed.name,
          stock_quantity: 500,
          required_quantity: 350,
          global_required_quantity: 350,
          status: {
            state: "sufficient",
            remaining_quantity: 150
          }
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
      snapshot = FeedConsumption::Snapshot.call(user:)
      result = described_class.call(groups: [ group ], snapshot:, days: 5)

      expect(result.size).to eq(2)
      expect(result).to eq([
        {
          feed_id: feed_one.id,
          feed_name: feed_one.name,
          stock_quantity: 100,
          required_quantity: 100,
          global_required_quantity: 100,
          status: {
            state: "sufficient",
            remaining_quantity: 0
          }
        },
        {
          feed_id: feed_two.id,
          feed_name: feed_two.name,
          stock_quantity: 50,
          required_quantity: 150,
          global_required_quantity: 150,
          status: {
            state: "shortage",
            missing_quantity: 100
          },
          groups: [
            {
              group_id: group_two.id,
              group_name: group_two.name,
              daily_required_quantity: 60
            }
          ]
        }
      ])
    end
  end
end
