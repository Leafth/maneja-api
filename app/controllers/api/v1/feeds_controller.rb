module Api
  module V1
    class FeedsController < BaseController
      before_action :authenticate_request!

      def create
        feed = Feeds::Create.call(name: feed_params[:name], initial_stock_quantity: feed_params[:initial_stock_quantity])
        render json: feed, serializer: FeedSerializer, status: :created
      end

      def show
        feed = Feeds::Find.call(id: params[:id])
        render json: feed, serializer: FeedSerializer
      end

      private

      def feed_params
        params.require(:feed).permit(:name, :initial_stock_quantity)
      end
    end
  end
end
