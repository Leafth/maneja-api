module Api
  module V1
    class GroupsController < BaseController
      before_action :authenticate_request!

      def create
        group = Groups::Create.call(attributes: group_params)
        render json: group, serializer: GroupSerializer, status: :created
      end

      private

      def group_params
        params.expect(group: [ :name, :animal_count ])
      end
    end
  end
end
