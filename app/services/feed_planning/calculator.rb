module FeedPlanning
  class Calculator
    class << self
      def call(groups:, snapshot:, days:, include_groups: false)
        selected_groups_ids = groups.map(&:id)

        snapshot.values.filter_map do |feed_data|
          selected_groups = selected_groups_for(
            feed_data:,
            selected_groups_ids:
          )

          next if selected_groups.empty?

          build_result(
            feed_data:,
            selected_groups:,
            days:,
            include_groups:
          )
        end
      end

      private

      def selected_groups_for(feed_data:, selected_groups_ids:)
        feed_data[:groups].select do |group_data|
          selected_groups_ids.include?(group_data[:group].id)
        end
      end

      def build_result(feed_data:, selected_groups:, days:, include_groups:)
        feed = feed_data[:feed]
        required_quantity = selected_groups.sum { |group| group[:daily_required_quantity] } * days
        global_required_quantity = feed_data[:daily_required_quantity] * days
        result = {
          feed_id: feed.id,
          feed_name: feed.name,
          stock_quantity: feed.stock_quantity,
          required_quantity:,
          global_required_quantity:,
          status: build_status(stock_quantity: feed.stock_quantity, required_quantity: global_required_quantity)
        }

        result[:groups] = build_groups(selected_groups) if include_groups

        result
      end

      def build_groups(groups)
        groups.map do |group_data|
          {
            group_id: group_data[:group].id,
            group_name: group_data[:group].name,
            daily_required_quantity: group_data[:daily_required_quantity]
          }
        end
      end

      def build_status(stock_quantity:, required_quantity:)
        difference = stock_quantity.to_d - required_quantity.to_d

        if difference.negative?
          {
            state: "shortage",
            missing_quantity: difference.abs
          }
        else
          {
            state: "sufficient",
            remaining_quantity: difference
          }
        end
      end
    end
  end
end
