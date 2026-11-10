module FeedPlanning
  class Calculator
    class << self
      def call(groups:, days:)
        totals_by_feed = {}

        groups.each do |group|
          group.feed_requirements.includes(:feed).each do |requirement|
            totals_by_feed[requirement.feed_id] ||= {
              feed: requirement.feed,
              required_quantity: 0.to_d
            }

            totals_by_feed[requirement.feed_id][:required_quantity] += requirement.quantity_per_animal_kg * group.animal_count * days
          end
        end

        totals_by_feed.values.map do |item|
          build_result(
            feed: item[:feed],
            required_quantity: item[:required_quantity]
          )
        end
      end

      private

      def build_result(feed:, required_quantity:)
        stock_quantity = feed.stock_quantity
        missing_quantity = [ required_quantity - stock_quantity, 0.to_d ].max
        {
          feed_id: feed.id,
          feed_name: feed.name,
          stock_quantity:,
          required_quantity:,
          missing_quantity:,
          sufficient: stock_quantity >= required_quantity
        }
      end
    end
  end
end
