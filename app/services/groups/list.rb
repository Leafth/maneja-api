module Groups
  class List
    class << self
      def call(user:, filters: {}, sort: nil, direction: nil, page:, per_page:)
        scope = Groups::Query.call(scope: user.groups.active, filters:, sort:, direction:)
        Pagination::Paginator.call(
          scope: scope,
          page:,
          per_page:
        )
      end
    end
  end
end
