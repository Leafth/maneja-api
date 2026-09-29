module Groups
  class List
    class << self
      def call(page:, per_page:)
        Pagination::Paginator.call(
          scope: Group.active.order(created_at: :desc),
          page:,
          per_page:
        )
      end
    end
  end
end
