module Pagination
  class Paginator
    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 10
    MAX_PER_PAGE = 100

    class << self
      def call(scope:, page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE)
        page = normalize_page(page)
        per_page = normalize_per_page(per_page)
        total_items = scope.count
        total_pages = (total_items.to_f / per_page).ceil

        records = scope.limit(per_page).offset((page - 1) * per_page)

        Result.new(
          records:,
          page:,
          per_page:,
          total_items:,
          total_pages:
        )
      end

      private

      def normalize_page(page)
        [ page.to_i, DEFAULT_PAGE ].max
      end

      def normalize_per_page(per_page)
        value = per_page.to_i
        return DEFAULT_PER_PAGE if value <= 0
        [ value, MAX_PER_PAGE ].min
      end
    end
  end
end
