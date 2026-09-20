module Auth
  class ResetPassword
    class << self
      def call(reset_password_token:, password:, password_confirmation:)
        User.transaction do
          user = User.reset_password_by_token(reset_password_token:, password:, password_confirmation:)

          raise ActiveRecord::RecordInvalid, user if user.errors.any?

          user.sessions.active.find_each(&:revoke!)

          user
        end
      end
    end
  end
end
