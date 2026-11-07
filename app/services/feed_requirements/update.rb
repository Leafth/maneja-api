module FeedRequirements
  class Update
    class << self
      def call(user:, group_id:, id:, feed_id:, quantity_per_animal_kg:)
        group = user.groups.active.find(group_id)
        feed_requirement = group.feed_requirements.find(id)
        feed = user.feeds.active.find(feed_id)

        feed_requirement.update!(
          feed:,
          quantity_per_animal_kg:
        )

        feed_requirement
      end
    end
  end
end
