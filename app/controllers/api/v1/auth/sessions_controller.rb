module Api
  module V1
    module Auth
      class SessionsController < BaseController
        def create
          tokens = ::Auth::AuthenticateUser.call(email: login_params[:email], password: login_params[:password])

          render json: tokens, status: :ok
        end

        private

        def login_params
          params.expect(user: [ :email, :password ])
        end
      end
    end
  end
end
