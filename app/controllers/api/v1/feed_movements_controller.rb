module Api
  module V1
    class FeedMovementsController < BaseController
      before_action :authenticate_request!

      def create_entry
        movement = FeedMovements::CreateEntry.call(
          feed_id: params[:feed_id],
          quantity: entry_params[:quantity],
          value: entry_params[:value],
          occurred_on: entry_params[:occurred_on]
        )
        render json: movement, serializer: FeedMovementSerializer, status: :created
      end

      def create_exit
        movement = FeedMovements::CreateExit.call(
          feed_id: params[:feed_id],
          quantity: exit_params[:quantity],
          reason: exit_params[:reason],
          occurred_on: exit_params[:occurred_on]
        )
        render json: movement, serializer: FeedMovementSerializer, status: :created
      end

      private

      def entry_params
        params.require(:entry).permit(:quantity, :value, :occurred_on)
      end

      def exit_params
        params.require(:exit).permit(:quantity, :reason, :occurred_on)
      end
    end
  end
end
