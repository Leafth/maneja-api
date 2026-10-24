module Api
  module V1
    class OccupationsController < BaseController
      before_action :authenticate_request!

      def create
        group = Groups::Find.call(user: current_user, id: occupation_params[:group_id])
        destination = Terrains::Find.call(id: occupation_params[:terrain_id])

        occupation = Occupations::Move.call(group:, destination:)

        render json: occupation, serializer: OccupationSerializer, status: :created
      end

      def by_group
        group = Groups::Find.call(user: current_user, id: params[:id])
        result = Occupations::HistoryByGroup.call(group:, page: params[:page], per_page: params[:per_page])
        paginated = PaginatedCollectionSerializer.call(result:, serializer: GroupOccupationHistorySerializer)

        render json: { group: GroupSummarySerializer.new(group).attributes, **paginated }
      end

      def by_terrain
        terrain = Terrains::Find.call(id: params[:id])
        result = Occupations::HistoryByTerrain.call(terrain:, page: params[:page], per_page: params[:per_page])
        paginated = PaginatedCollectionSerializer.call(result:, serializer: TerrainOccupationHistorySerializer)

        render json: { terrain: TerrainSummarySerializer.new(terrain).attributes, **paginated }
      end

      private

      def occupation_params
        params.expect(occupation: [ :group_id, :terrain_id ])
      end
    end
  end
end
