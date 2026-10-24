module Feeds
  class Query
    FILTERS = {
      name: ->(scope, value) { scope.where("name ILIKE ?", "%#{value}%") },
      min_stock_quantity: ->(scope, value) { scope.where("stock_quantity >= ?", value) },
      max_stock_quantity: ->(scope, value) { scope.where("stock_quantity <= ?", value) }
    }.freeze

    SORTS = {
      name: :name,
      stock_quantity: :stock_quantity,
      created_at: :created_at
    }.freeze

    DEFAULT_SORT = { updated_at: :desc }.freeze

    class << self
      def call(filters: {}, sort: nil, direction: nil)
        scope = Filtering::Filterer.call(scope: Feed.active, filters:, definitions: FILTERS)
        Sorting::Sorter.call(scope: scope, sort:, direction:, allowed: SORTS, default: DEFAULT_SORT)
      end
    end
  end
end
