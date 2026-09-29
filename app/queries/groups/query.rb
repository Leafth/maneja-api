module Groups
  class Query
    FILTERS = {
      name: ->(scope, value) { scope.where("name ILIKE ?", "%#{value}%") },
      min_animal_count: ->(scope, value) { scope.where("animal_count >= ?", value) },
      max_animal_count: ->(scope, value) { scope.where("animal_count <= ?", value) }
    }.freeze

    SORTS = {
      name: :name,
      animal_count: :animal_count,
      created_at: :created_at
    }.freeze

    DEFAULT_SORT = { created_at: :desc }.freeze

    class << self
      def call(filters: {}, sort: nil, direction: nil)
        scope = Filtering::Filterer.call(scope: Group.all, filters:, definitions: FILTERS)
        Sorting::Sorter.call(scope: scope, sort:, direction:, allowed: SORTS, default: DEFAULT_SORT)
      end
    end
  end
end
