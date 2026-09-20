module Auth
  class RegisterUser
    class << self
      def call(attributes:)
        User.transaction do
          user = User.create!(attributes)

          tokens = CreateSession.call(user:)

          { user:, tokens: }
        end
      end
    end
  end
end
