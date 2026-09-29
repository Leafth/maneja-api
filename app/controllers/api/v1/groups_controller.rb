module Api
  module V1
    class GroupsController < BaseController
      before_action :authenticate_request!

      def create
        group = Groups::Create.call(attributes: group_params)
        render json: group, serializer: GroupSerializer, status: :created
      end

      def index
        result = Groups::List.call(
          filters: params.permit(:name, :min_animal_count, :max_animal_count).to_h,
          sort: params[:sort],
          direction: params[:direction],
          page: params[:page], per_page: params[:per_page])
        render json: PaginatedCollectionSerializer.call(result:, serializer: GroupSerializer)
      end

      def show
        group = Groups::Find.call(id: params[:id])
        render json: group, serializer: GroupSerializer, status: :ok
      end

      def update
        group = Groups::Update.call(id: params[:id], attributes: group_params)
        render json: group, serializer: GroupSerializer, status: :ok
      end

      def destroy
        Groups::Delete.call(id: params[:id])
        head :no_content
      end

      private

      def group_params
        params.expect(group: [ :name, :animal_count ])
      end
    end
  end
end
