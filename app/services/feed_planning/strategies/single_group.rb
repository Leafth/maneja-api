module FeedPlanning
  module Strategies
    class SingleGroup
      class << self
        def call(user:, group_id:)
          [ user.groups.active.find(group_id) ]
        end
      end
    end
  end
end
