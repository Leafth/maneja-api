module FeedRequirements
  class Destroy
    class << self
      def call(user:, group_id:, id:)
        group = user.groups.active.find(group_id)
        feed_requirement = group.feed_requirements.find(id)

        feed_requirement.destroy!

        feed_requirement
      end
    end
  end
end
