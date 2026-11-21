module Overview
  class Show
    class << self
      def call(user:)
        {
          herd: herd_summary(user),
          terrains: terrains_summary(user),
          feed_alerts: feed_alerts(user)
        }
      end

      private

      def herd_summary(user)
        groups = user.groups.active

        {
          groups: groups.count,
          animals: groups.sum(:animal_count)
        }
      end

      def terrains_summary(user)
        terrains = user.terrains.active

        {
          total: terrains.count,
          available: terrains.available.count,
          occupied: terrains.occupied.count,
          resting: terrains.resting.count
        }
      end

      def feed_alerts(user)
        FeedAlerts::List.call(user:).first(3)
      end
    end
  end
end
