module Api
  module V1
    class OverviewController < BaseController
      before_action :authenticate_request!

      def show
        render json: Overview::Show.call(user: current_user), status: :ok
      end
    end
  end
end
