module Terrains
  class List
    class << self
      def call(filters: {}, sort: nil, direction: nil, page: nil, per_page: nil)
        scope = Terrains::Query.call(filters:, sort:, direction:)
        Pagination::Paginator.call(scope: scope, page:, per_page:)
      end
    end
  end
end
