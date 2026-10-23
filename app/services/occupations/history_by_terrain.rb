module Occupations
  class HistoryByTerrain
    class << self
      def call(terrain:, page:, per_page:)
        scope = terrain.occupations.includes(:group, :terrain).order(started_at: :desc)

        Pagination::Paginator.call(scope:, page:, per_page:)
      end
    end
  end
end
