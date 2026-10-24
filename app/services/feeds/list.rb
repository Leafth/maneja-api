module Feeds
  class List
    class << self
      def call(filters: {}, sort: nil, direction: nil, page:, per_page:)
        scope = Feeds::Query.call(filters:, sort:, direction:)
        Pagination::Paginator.call(
          scope: scope,
          page:,
          per_page:
        )
      end
    end
  end
end
