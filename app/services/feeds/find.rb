module Feeds
  class Find
    class << self
      def call(id:)
        Feed.active.find(id)
      end
    end
  end
end
