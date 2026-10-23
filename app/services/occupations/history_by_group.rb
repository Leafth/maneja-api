module Occupations
  class HistoryByGroup
    class << self
      def call(group:, page:, per_page:)
        scope = group.occupations.order(started_at: :desc)

        Pagination::Paginator.call(scope:, page:, per_page:)
      end
    end
  end
end
