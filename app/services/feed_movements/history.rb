module FeedMovements
  class History
    class << self
      def call(feed_id:, page:, per_page:)
        feed = Feeds::Find.call(id: feed_id)
        scope = feed.feed_movements.order(occurred_on: :desc, created_at: :desc)
        Pagination::Paginator.call(
          scope:,
          page:,
          per_page:
        )
      end
    end
  end
end
