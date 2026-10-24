module Feeds
  class Find
    class << self
      def call(user:, id:)
        user.feeds.active.find(id)
      end
    end
  end
end
