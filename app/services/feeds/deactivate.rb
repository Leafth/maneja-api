module Feeds
  class Deactivate
    class << self
      def call(id:)
        feed = Feeds::Find.call(id:)
        feed.soft_delete!
        feed
      end
    end
  end
end
