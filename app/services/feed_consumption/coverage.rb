module FeedConsumption
  class Coverage
    class << self
      def call(stock_quantity:, daily_required_quantity:)
        daily_required_quantity = daily_required_quantity.to_d

        return without_consumption unless daily_required_quantity.positive?

        days_remaining = (stock_quantity.to_d / daily_required_quantity).floor

        {
          days_remaining:,
          alert_level: AlertLevels.resolve(days_remaining)
        }
      end

      private

      def without_consumption
        {
          days_remaining: nil,
          alert_level: nil
        }
      end
    end
  end
end
