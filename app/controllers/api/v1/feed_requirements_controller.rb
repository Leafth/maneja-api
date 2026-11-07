module Api
  module V1
    class FeedRequirementsController < BaseController
      before_action :authenticate_request!

      def create
        feed_requirement = FeedRequirements::Create.call(
          user: current_user,
          group_id: params[:group_id],
          feed_id: feed_requirement_params[:feed_id],
          quantity_per_animal_kg: feed_requirement_params[:quantity_per_animal_kg]
        )

        render json: feed_requirement, serializer: FeedRequirementSerializer, status: :created
      end

      def index
        feed_requirements = FeedRequirements::List.call(
          user: current_user,
          group_id: params[:group_id]
        )

        render json: feed_requirements, each_serializer: FeedRequirementSerializer
      end

      private

      def feed_requirement_params
        params.require(:feed_requirement).permit(:feed_id, :quantity_per_animal_kg)
      end
    end
  end
end
