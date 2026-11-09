module Feedings
  class History
    class << self
      def call(user:, group_id:, page:, per_page:)
        group = user.groups.active.find(group_id)

        scope = group.feedings.includes(:feed).order(occurred_at: :desc, created_at: :desc)

        Pagination::Paginator.call(scope:, page:, per_page:)
      end
    end
  end
end
