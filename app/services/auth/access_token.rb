module Auth
  class AccessToken
    ALGORITHM = "HS256"

    class << self
      def encode(user:, session:)
        payload = {
          sub: user.id,
          sid: session.id,
          iat: Time.current.to_i,
          exp: expiration.from_now.to_i
        }

        JWT.encode(payload, ENV.fetch("JWT_SECRET"), ALGORITHM)
      end

      def decode(token)
        payload, = JWT.decode(token, secret_key, true, algorithm: ALGORITHM)

        payload.with_indifferent_access

      rescue JWT::ExpiredSignature
        raise AuthenticationError, I18n.t("errors.authentication.expired_token")
      rescue JWT::DecodeError
        raise AuthenticationError, I18n.t("errors.authentication.invalid_token")
      end

      private

      def secret_key
        ENV.fetch("JWT_SECRET")
      end

      def expiration
        ENV.fetch("ACCESS_TOKEN_EXPIRATION_MINUTES", 15).to_i.minutes
      end
    end
  end
end
