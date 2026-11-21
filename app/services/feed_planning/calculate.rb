module FeedPlanning
  class Calculate
    class << self
      def call(user:, scope:, start_date:, end_date:, group_id: nil)
        start_date = Date.parse(start_date.to_s)
        end_date = Date.parse(end_date.to_s)

        validate_period!(start_date:, end_date:)

        groups = select_groups(user:, scope:, group_id:)
        days = (end_date - start_date).to_i + 1

        snapshot = FeedConsumption::Snapshot.call(user:)

        data = Calculator.call(groups:, snapshot:, days:, include_groups: scope == "all")

        {
          period: {
            start_date:,
            end_date:,
            days:
          },
          scope: build_scope(scope:, group_id:),
          status: build_status(data),
          data:
        }
      end

      private

      def validate_period!(start_date:, end_date:)
        return if start_date <= end_date

        raise ApplicationError, I18n.t("errors.feed_planning.invalid_period")
      end

      def select_groups(user:, scope:, group_id:)
        case scope
        when "group"
          raise ApplicationError, I18n.t("errors.feed_planning.group_id_required") if group_id.blank?

          FeedPlanning::Strategies::SingleGroup.call(user:, group_id:)
        when "all"
          FeedPlanning::Strategies::AllGroups.call(user:)
        else
          raise ApplicationError, I18n.t("errors.feed_planning.invalid_scope")
        end
      end

      def build_scope(scope:, group_id:)
        return { type: "all" } if scope == "all"

        { type: "group", group_id: group_id }
      end

      def build_status(data)
        shortage_count = data.count do |item|
          item[:status][:state] == "shortage"
        end

        {
          state: shortage_count.positive? ? "shortage" : "sufficient",
          shortage_count:
        }
      end
    end
  end
end
