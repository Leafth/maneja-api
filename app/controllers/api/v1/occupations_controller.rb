module Api
  module V1
    class OccupationsController < BaseController
      before_action :authenticate_request!

      def create
        group = Groups::Find.call(id: occupation_params[:group_id])
        destination = Terrains::Find.call(id: occupation_params[:terrain_id])

        occupation = Occupations::Move.call(group:, destination:)

        render json: occupation, serializer: OccupationSerializer, status: :created
      end

      def by_group
        group = Groups::Find.call(id: params[:id])
        result = Occupations::HistoryByGroup.call(group:, page: params[:page], per_page: params[:per_page])

        render json: PaginatedCollectionSerializer.call(result:, serializer: OccupationSerializer)
      end

      private

      def occupation_params
        params.expect(occupation: [ :group_id, :terrain_id ])
      end
    end
  end
end
