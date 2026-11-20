module Concerns
  module FeedConsumptionAttributes
    extend ActiveSupport::Concern

    def include_consumption?
      instance_options[:include_consumption]
    end

    def daily_required_quantity
      feed_data[:daily_required_quantity]
    end

    def days_remaining
      coverage[:days_remaining]
    end

    def alert_level
      coverage[:alert_level]
    end

    private

    def feed_data
      consumption_snapshot[object.id] || {
        feed: object,
        daily_required_quantity: 0.to_d,
        groups: []
      }
    end

    def coverage
      @coverage ||= FeedConsumption::Coverage.call(
        stock_quantity: object.stock_quantity,
        daily_required_quantity: feed_data[:daily_required_quantity]
      )
    end

    def consumption_snapshot
      instance_options[:consumption_snapshot] || {}
    end
  end
end
