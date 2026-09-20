module Auth
  class RequestPasswordReset
    class << self
      def call(email:)
        User.send_reset_password_instructions(email:)
      end
    end
  end
end
