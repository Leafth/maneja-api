module Feedings
  class Create
    class << self
      def call(user:, group_id:, feed_id:, quantity:, occurred_at:)
        group = user.groups.active.find(group_id)
        feed = user.feeds.active.find(feed_id)

        ApplicationRecord.transaction do
          feeding = Feeding.create!(
            group: group,
            feed: feed,
            quantity: quantity,
            occurred_at: occurred_at
          )

          FeedMovements::CreateExit.call(
            user:,
            feed_id: feed.id,
            quantity:,
            reason: I18n.t("feed_movements.reasons.feeding", group_name: group.name,),
            occurred_on: occurred_at.to_date
          )

          feeding
        end
      end
    end
  end
end
