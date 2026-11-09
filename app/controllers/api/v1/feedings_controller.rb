module Api
  module V1
    class FeedingsController < BaseController
      before_action :authenticate_request!

      def create
        feeding = Feedings::Create.call(
          user: current_user,
          group_id: params[:group_id],
          feed_id: feeding_params[:feed_id],
          quantity: feeding_params[:quantity],
          occurred_at: feeding_params[:occurred_at]
        )

        render json: feeding, serializer: FeedingSerializer, include_group_id: true, status: :created
      end

      def index
        result = Feedings::History.call(
          user: current_user,
          group_id: params[:group_id],
          page: params[:page],
          per_page: params[:per_page]
        )

        paginated = PaginatedCollectionSerializer.call(result:, serializer: FeedingSerializer)

        render json: { group_id: params[:group_id], **paginated }
      end

      private

      def feeding_params
        params.require(:feeding).permit(:feed_id, :quantity, :occurred_at)
      end
    end
  end
end
