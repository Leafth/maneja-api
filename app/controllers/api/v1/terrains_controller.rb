module Api
  module V1
    class TerrainsController < BaseController
      before_action :authenticate_request!

      def create
        terrain = Terrains::Create.call(attributes: terrain_params)
        render json: terrain, serializer: TerrainSerializer, status: :created
      end

      private

      def terrain_params
        params.expect(terrain: [ :name, :rest_days ])end
    end
  end
end
