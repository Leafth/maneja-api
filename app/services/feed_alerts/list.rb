module FeedAlerts
  class List
    class << self
      def call(user:)
        snapshot = FeedConsumption::Snapshot.call(user:)

        alerts = snapshot.values.filter_map do |item|
          build_alert(item)
        end

        sort(alerts)
      end

      private

      def build_alert(item)
        feed = item[:feed]
        daily_required_quantity = item[:daily_required_quantity]

        coverage = FeedConsumption::Coverage.call(
          stock_quantity: feed.stock_quantity,
          daily_required_quantity:
        )

        return if coverage[:alert_level].nil?

        {
          feed_id: feed.id,
          feed_name: feed.name,
          stock_quantity: feed.stock_quantity,
          daily_required_quantity:,
          days_remaining: coverage[:days_remaining],
          alert_level: coverage[:alert_level]
        }
      end

      def sort(alerts)
        alerts.sort_by do |alert|
          [
            FeedConsumption::AlertLevels.priority(alert[:alert_level]),
            alert[:days_remaining]
          ]
        end
      end
    end
  end
end
