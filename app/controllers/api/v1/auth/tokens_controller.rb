module Api
  module V1
    module Auth
      class TokensController < BaseController
        def create
          tokens = ::Auth::RefreshSession.call(refresh_token: params.expect(:refresh_token))

          render json: tokens, status: :ok
        end
      end
    end
  end
end
