module Feeds
  class Deactivate
    class << self
      def call(user:, id:)
        feed = Feeds::Find.call(user:, id:)
        feed.soft_delete!
        feed
      end
    end
  end
end
