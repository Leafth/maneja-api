module FeedMovements
  class CreateEntry
    class << self
      def call(feed_id:, quantity:, value:, occurred_on:)
        ActiveRecord::Base.transaction do
          feed = Feed.active.lock.find(feed_id)

          movement = FeedMovement.create!(
            feed: feed,
            movement_type: :entry,
            quantity: quantity,
            value: value,
            occurred_on: occurred_on
          )

          feed.update!(stock_quantity: feed.stock_quantity + quantity)

          movement
        end
      end
    end
  end
end
