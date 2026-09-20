module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content
      rescue_from ActionController::ParameterMissing, with: :render_bad_request
      rescue_from ApplicationError, with: :render_application_error
      rescue_from AuthenticationError, with: :render_authentication_error
      rescue_from AuthorizationError, with: :render_authorization_error

      attr_reader :current_user, :current_session

      private

      def authenticate_request!
        payload = ::Auth::AccessToken.decode(bearer_token)

        @current_user = User.find(payload[:sub])
        @current_session = Session.active.find_by(id: payload[:sid], user: current_user)

        unless current_session
          raise AuthenticationError, I18n.t("errors.authentication.invalid_token")
        end
      rescue ActiveRecord::RecordNotFound
        raise AuthenticationError, I18n.t("errors.authentication.invalid_token")
      end

      def bearer_token
        scheme, token = request.headers["Authorization"].to_s.split(" ", 2)

        return token if scheme&.casecmp("Bearer")&.zero? && token.present?

        raise AuthenticationError, I18n.t("errors.authentication.missing_token")
      end

      def render_not_found(error)
        render json: {
          errors: {
            resource: [ error.message ]
          }
        }, status: :not_found
      end

      def render_unprocessable_content(error)
        render json: {
          errors: error.record.errors.to_hash(true)
        }, status: :unprocessable_content
      end

      def render_bad_request(error)
        render json: {
          errors: {
            base: [ error.message ]
          }
        }, status: :bad_request
      end

      def render_application_error(error)
        render json: {
          errors: {
            base: [ error.message ]
          }
        }, status: :unprocessable_content
      end

      def render_authentication_error(error)
        render json: {
          errors: {
            base: [ error.message ]
          }
        }, status: :unauthorized
      end
    end
  end
end
