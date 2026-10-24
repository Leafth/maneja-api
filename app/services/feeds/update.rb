module Feeds
  class Update
    class << self
      def call(id:, name:)
        feed = Feeds::Find.call(id:)
        feed.update!(name:)
        feed
      end
    end
  end
end
