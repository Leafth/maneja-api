module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
      rescue_from ActionController::ParameterMissing, with: :render_bad_request
      rescue_from ApplicationError, with: :render_application_error
      rescue_from AuthenticationError, with: :render_authentication_error

      private

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
