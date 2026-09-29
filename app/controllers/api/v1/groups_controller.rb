module Api
  module V1
    class GroupsController < BaseController
      before_action :authenticate_request!

      def create
        group = Groups::Create.call(attributes: group_params)
        render json: group, serializer: GroupSerializer, status: :created
      end

      def index
        result = Groups::List.call(page: params[:page], per_page: params[:per_page])
        render json: PaginatedCollectionSerializer.call(result:, serializer: GroupSerializer)
      end

      private

      def group_params
        params.expect(group: [ :name, :animal_count ])
      end
    end
  end
end
