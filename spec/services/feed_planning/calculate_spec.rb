require "rails_helper"

RSpec.describe FeedPlanning::Calculate, type: :service do
  describe ".call" do
    it "calculates the feed planning for a single group" do
      user = create(:user)
      group = create(:group, user:, animal_count: 10)
      feed = create(:feed, user:, stock_quantity: 100)
      create(:feed_requirement, group:, feed:, quantity_per_animal_kg: 2)

      result = described_class.call(
        user:,
        scope: "group",
        group_id: group.id,
        start_date: Date.today,
        end_date: Date.today + 4
      )

      expect(result[:period]).to eq({
        start_date: Date.today,
        end_date: Date.today + 4,
        days: 5
      })

      expect(result[:scope]).to eq({ type: "group", group_id: group.id })

      expect(result[:data].size).to eq(1)
      expect(result[:data]).to eq([
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

    it "calculates the feed planning for all groups" do
      user = create(:user)
      group_one = create(:group, user:, animal_count: 10)
      group_two = create(:group, user:, animal_count: 20)
      feed_one = create(:feed, user:, stock_quantity: 100)
      feed_two = create(:feed, user:, stock_quantity: 200)
      create(:feed_requirement, group: group_one, feed: feed_one, quantity_per_animal_kg: 2)
      create(:feed_requirement, group: group_two, feed: feed_two, quantity_per_animal_kg: 3)

      result = described_class.call(
        user:,
        scope: "all",
        start_date: Date.today,
        end_date: Date.today + 4
      )

      expect(result[:period]).to eq({
        start_date: Date.today,
        end_date: Date.today + 4,
        days: 5
      })

      expect(result[:scope]).to eq({ type: "all" })

      expect(result[:data].size).to eq(2)
      expect(result[:data]).to include(
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
          stock_quantity: 200,
          required_quantity: 300,
          missing_quantity: 100,
          sufficient: false
        }
      )
    end

    it "requires a valid period" do
      user = create(:user)
      group = create(:group, user:, animal_count: 10)

      expect {
        described_class.call(
          user:,
          scope: "group",
          group_id: group.id,
          start_date: Date.today + 1,
          end_date: Date.today
        )
      }.to raise_error(ApplicationError, I18n.t("errors.feed_planning.invalid_period"))
    end

    it "requires a group_id when scope is 'group'" do
      user = create(:user)

      expect {
        described_class.call(
          user:,
          scope: "group",
          group_id: nil,
          start_date: Date.today,
          end_date: Date.today + 4
        )
      }.to raise_error(ApplicationError, I18n.t("errors.feed_planning.group_id_required"))
    end

    it "requires a valid scope" do
      user = create(:user)

      expect {
        described_class.call(
          user:,
          scope: "invalid_scope",
          start_date: Date.today,
          end_date: Date.today + 4
        )
      }.to raise_error(ApplicationError, I18n.t("errors.feed_planning.invalid_scope"))
    end
  end
end
