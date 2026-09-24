module Auth
  class VerifyPasswordResetCode
    class << self
      def call(code:)
        user = User.with_reset_password_token(code)

        unless user&.reset_password_period_valid?
          raise AuthenticationError, I18n.t("errors.authentication.invalid_password_reset_code")
        end

        user.generate_token_for(:password_reset_verification)
      end
    end
  end
end
