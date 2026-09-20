module Api
  module V1
    module Auth
      class SessionsController < BaseController
        before_action :authenticate_request!, only: [ :show, :destroy ]

        def create
          tokens = ::Auth::AuthenticateUser.call(email: login_params[:email], password: login_params[:password])

          render json: tokens, status: :ok
        end

        def show
          render json: {
            id: current_user.id,
            name: current_user.name,
            email: current_user.email
          }, status: :ok
        end

        def destroy
          current_session.revoke!

          head :no_content
        end
        private

        def login_params
          params.expect(user: [ :email, :password ])
        end
      end
    end
  end
end
