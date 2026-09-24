module Api
  module V1
    class PasswordsController < BaseController
      rate_limit to: 5,
                 within: 1.minute,
                 only: :verify,
                 name: "password_reset_verify",
                 with: :render_verify_rate_limit

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

      def render_verify_rate_limit
        render json: { errors: { base: [ I18n.t("errors.rate_limit.password_reset_verify") ] } },
               status: :too_many_requests
      end
    end
  end
end
