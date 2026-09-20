module Api
  module V1
    class PasswordsController < BaseController
      def forgot
        ::Auth::RequestPasswordReset.call(email: params.expect(:email))

        head :no_content
      end
    end
  end
end
