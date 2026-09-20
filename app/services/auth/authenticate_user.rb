module Auth
  class AuthenticateUser
    class << self
      def call(email:, password:)
        user = User.find_for_database_authentication(email:)

        unless user&.valid_password?(password)
          raise AuthenticationError, I18n.t("devise.failure.invalid", authentication_keys: User.human_attribute_name(:email))
        end

        CreateSession.call(user:)
      end
    end
  end
end
