module FeedPlanning
  module Strategies
    class AllGroups
      class << self
        def call(user:)
          user.groups.active
        end
      end
    end
  end
end
