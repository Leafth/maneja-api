module FeedPlanning
  class Calculate
    class << self
      def call(user:, scope:, start_date:, end_date:, group_id: nil)
        start_date = Date.parse(start_date.to_s)
        end_date = Date.parse(end_date.to_s)

        validate_period!(start_date:, end_date:)

        groups = select_groups(user:, scope:, group_id:)
        days = (end_date - start_date).to_i + 1

        {
          period: {
            start_date:,
            end_date:,
            days:
          },
          scope: build_scope(scope:, group_id:),
          data: FeedPlanning::Calculator.call(groups:, days:)
        }
      end

      private

      def validate_period!(start_date:, end_date:)
        return if start_date <= end_date

        raise ArgumentError, I18n.t("errors.feed_planning.invalid_period")
      end

      def select_groups(user:, scope:, group_id:)
        case scope
        when "group"
          raise ArgumentError, I18n.t("errors.feed_planning.group_id_required") if group_id.blank?

          FeedPlanning::Strategies::SingleGroup.call(user:, group_id:)
        when "all"
          FeedPlanning::Strategies::AllGroups.call(user:)
        else
          raise ArgumentError, I18n.t("errors.feed_planning.invalid_scope")
        end
      end

      def build_scope(scope:, group_id:)
        return { type: "all" } if scope == "all"

        { type: "group", group_id: group_id }
      end
    end
  end
end
