module Api
  module V1
    class TerrainsController < BaseController
      before_action :authenticate_request!

      def create
        terrain = Terrains::Create.call(attributes: terrain_params)
        render json: terrain, serializer: TerrainSerializer, status: :created
      end

      def index
        result = Terrains::List.call(
          filters: params.permit(:name, :status, :min_rest_days, :max_rest_days).to_h,
          sort: params[:sort],
          direction: params[:direction],
          page: params[:page], per_page: params[:per_page])
        render json: PaginatedCollectionSerializer.call(result:, serializer: TerrainSerializer)
      end

      def show
        terrain = Terrains::Find.call(id: params[:id])
        render json: terrain, serializer: TerrainSerializer, status: :ok
      end

      def update
        terrain = Terrains::Update.call(id: params[:id], attributes: terrain_params)
        render json: terrain, serializer: TerrainSerializer, status: :ok
      end

      private

      def terrain_params
        params.expect(terrain: [ :name, :rest_days ])end
    end
  end
end
