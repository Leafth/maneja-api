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

        render json: feed_requirement, serializer: FeedRequirementSerializer, include_group_id: true, status: :created
      end

      def index
        feed_requirements = FeedRequirements::List.call(
          user: current_user,
          group_id: params[:group_id]
        )

        data = feed_requirements.map do |feed_requirement|
          FeedRequirementSerializer.new(feed_requirement, include_total_daily_kg: true).attributes
        end

        render json: {
          group_id: params[:group_id],
          feed_requirements: data
        }, status: :ok
      end

      def update
        feed_requirement = FeedRequirements::Update.call(
          user: current_user,
          group_id: params[:group_id],
          id: params[:id],
          feed_id: feed_requirement_params[:feed_id],
          quantity_per_animal_kg: feed_requirement_params[:quantity_per_animal_kg]
        )

        render json: feed_requirement, serializer: FeedRequirementSerializer, include_group_id: true, status: :ok
      end

      def destroy
        FeedRequirements::Destroy.call(
          user: current_user,
          group_id: params[:group_id],
          id: params[:id]
        )

        head :no_content
      end

      private

      def feed_requirement_params
        params.require(:feed_requirement).permit(:feed_id, :quantity_per_animal_kg)
      end
    end
  end
end
