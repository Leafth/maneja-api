module FeedRequirements
  class Create
    class << self
      def call(user:, group_id:, feed_id:, quantity_per_animal_kg:)
        group = user.groups.active.find(group_id)
        feed = user.feeds.active.find(feed_id)

        FeedRequirement.create!(
          group:,
          feed:,
          quantity_per_animal_kg:
        )
      end
    end
  end
end
