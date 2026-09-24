module Auth
  class RefreshSession
    class << self
      def call(refresh_token:)
        digest = RefreshToken.digest(refresh_token)

        Session.transaction do
          session = Session.active.lock.find_by(refresh_token_digest: digest)

          raise AuthenticationError, I18n.t("errors.authentication.expired_token") unless session

          new_refresh_token = RefreshToken.generate

          session.update!(
            refresh_token_digest: RefreshToken.digest(new_refresh_token),
          )

          access_token = AccessToken.encode(user: session.user, session: session)

          { access_token:, refresh_token: new_refresh_token }
        end
      end
    end
  end
end
