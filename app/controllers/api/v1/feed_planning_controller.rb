module Api
  module V1
    class FeedPlanningController < BaseController
      before_action :authenticate_request!

      def create
        result = FeedPlanning::Calculate.call(
          user: current_user,
          scope: feed_planning_params[:scope],
          group_id: feed_planning_params[:group_id],
          start_date: feed_planning_params[:start_date],
          end_date: feed_planning_params[:end_date]
        )

        render json: result, status: :ok
      end

      private

      def feed_planning_params
        params.require(:feed_planning).permit(:scope, :group_id, :start_date, :end_date)
      end
    end
  end
end
