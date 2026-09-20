module Api
  module V1
    class PasswordsController < BaseController
      def forgot
        ::Auth::RequestPasswordReset.call(email: params.expect(:email))

        head :no_content
      end

      def reset
        token, password, password_confirmation = reset_password_params

        ::Auth::ResetPassword.call(
          reset_password_token: token,
          password:,
          password_confirmation:
        )

        head :no_content
      end

      private

      def reset_password_params
        params.expect(:token, :password, :password_confirmation)
      end
    end
  end
end
