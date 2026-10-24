module Feeds
  class List
    class << self
      def call(user:, filters: {}, sort: nil, direction: nil, page:, per_page:)
        scope = Feeds::Query.call(scope: user.feeds.active, filters:, sort:, direction:)
        Pagination::Paginator.call(
          scope: scope,
          page:,
          per_page:
        )
      end
    end
  end
end
