module FeedConsumption
  class Snapshot
    class << self
      def call(user:)
        snapshot = build_initial_snapshot(user)

        requirements_for(user).each do |requirement|
          feed_data = snapshot[requirement.feed_id]

          next unless feed_data

          daily_quantity = requirement.daily_quantity
          feed_data[:daily_required_quantity] += daily_quantity

          feed_data[:groups] << {
            group: requirement.group,
            daily_required_quantity: daily_quantity
          }
        end

        snapshot
      end

      private

      def build_initial_snapshot(user)
        user.feeds.active.each_with_object({}) do |feed, snapshot|
          snapshot[feed.id] = {
            feed:,
            daily_required_quantity: 0.to_d,
            groups: []
          }
        end
      end

      def requirements_for(user)
        FeedRequirement
          .where(group_id: user.groups.select(:id))
          .includes(:group, :feed)
      end
    end
  end
end
