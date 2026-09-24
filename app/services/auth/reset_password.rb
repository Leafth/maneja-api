module Auth
  class ResetPassword
    class << self
      def call(reset_token:, password:, password_confirmation:)
        user = User.find_by_token_for(:password_reset_verification, reset_token)

        raise AuthenticationError, I18n.t("errors.authentication.invalid_password_reset_token") unless user

        User.transaction do
          user.reset_password(password, password_confirmation)

          raise ActiveRecord::RecordInvalid, user if user.errors.any?

          user.sessions.active.find_each(&:revoke!)

          user
        end
      end
    end
  end
end
