module FeedMovements
  class CreateExit
    class << self
      def call(user:, feed_id:, quantity:, reason:, occurred_on:)
        ActiveRecord::Base.transaction do
          feed = user.feeds.active.lock.find(feed_id)

          movement = FeedMovement.new(
            feed:,
            movement_type: :exit,
            quantity:,
            reason:,
            occurred_on:
          )

          movement.validate!

          validate_stock!(feed:, quantity: movement.quantity)

          movement.save!

          feed.update!(stock_quantity: feed.stock_quantity - movement.quantity)

          movement
        end
      end

      private

      def validate_stock!(feed:, quantity:)
        return if feed.stock_quantity >= quantity

        feed.errors.add(:stock_quantity, I18n.t("errors.feed_movements.insufficient_stock"))
        raise ActiveRecord::RecordInvalid.new(feed)
      end
    end
  end
end
