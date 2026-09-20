module Auth
  class CreateSession
    class << self
      def call(user:)
        refresh_token = RefreshToken.generate

        Session.transaction do
          session = Session.create!(
            user: user,
            refresh_token_digest: RefreshToken.digest(refresh_token),
            expires_at: refresh_token_expiration.from_now
          )

          access_token = AccessToken.encode(user:, session:)

          { access_token:, refresh_token: }
        end
      end

      private

      def refresh_token_expiration
        ENV.fetch("REFRESH_TOKEN_EXPIRATION_DAYS", 30).to_i.days
      end
    end
  end
end
