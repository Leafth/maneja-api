module Feeds
  class Update
    class << self
      def call(user:, id:, name:)
        feed = Feeds::Find.call(user:, id:)
        feed.update!(name:)
        feed
      end
    end
  end
end
