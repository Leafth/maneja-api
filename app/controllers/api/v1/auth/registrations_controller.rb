module Api
  module V1
    module Auth
      class RegistrationsController < BaseController
        def create
          result = ::Auth::RegisterUser.call(attributes: registration_params)

          render json: {
            user: {
              id: result[:user].id,
              name: result[:user].name,
              email: result[:user].email
            },
            access_token: result[:tokens][:access_token],
            refresh_token: result[:tokens][:refresh_token]
          }, status: :created
        end

        private

        def registration_params
          params.expect(user: [ :name, :email, :password, :password_confirmation ])
        end
      end
    end
  end
end
