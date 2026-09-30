module Terrains
  class Query
    FILTERS = {
      name: ->(scope, value) { scope.where("name ILIKE ?", "%#{value}%") },
      status: ->(scope, value) { scope.where(status: value) },
      min_rest_days: ->(scope, value) { scope.where("rest_days >= ?", value) },
      max_rest_days: ->(scope, value) { scope.where("rest_days <= ?", value) }
    }.freeze

    SORTS = {
      name: :name,
      rest_days: :rest_days,
      created_at: :created_at
    }.freeze

    DEFAULT_SORT = { updated_at: :desc }.freeze

    class << self
      def call(filters: {}, sort: nil, direction: nil)
        scope = Filtering::Filterer.call(scope: Terrain.active, filters:, definitions: FILTERS)
        Sorting::Sorter.call(scope: scope, sort:, direction:, allowed: SORTS, default: DEFAULT_SORT)
      end
    end
  end
end
