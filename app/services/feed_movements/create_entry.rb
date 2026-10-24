module FeedMovements
  class CreateEntry
    class << self
      def call(user:, feed_id:, quantity:, value:, occurred_on:)
        ActiveRecord::Base.transaction do
          feed = user.feeds.active.lock.find(feed_id)

          movement = FeedMovement.create!(
            feed:,
            movement_type: :entry,
            quantity:,
            value:,
            occurred_on:
          )

          feed.update!(stock_quantity: feed.stock_quantity + quantity)

          movement
        end
      end
    end
  end
end
