module Api
  module V1
    class PasswordsController < BaseController
      def forgot
        ::Auth::RequestPasswordReset.call(email: params.expect(:email))

        head :no_content
      end

      def verify
        reset_token = ::Auth::VerifyPasswordResetCode.call(code: params.expect(:code))

        render json: { reset_token: }, status: :ok
      end

      def reset
        reset_token, password, password_confirmation = reset_password_params

        ::Auth::ResetPassword.call(
          reset_token:,
          password:,
          password_confirmation:
        )

        head :no_content
      end

      private

      def reset_password_params
        params.expect(:reset_token, :password, :password_confirmation)
      end
    end
  end
end
