module FeedRequirements
  class List
    class << self
      def call(user:, group_id:)
        group = user.groups.active.find(group_id)

        group.feed_requirements.includes(:feed)
      end
    end
  end
end
