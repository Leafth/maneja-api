module Groups
  class Create
    class << self
      def call(user:, attributes:)
        user.groups.create!(attributes.merge(user:))
      end
    end
  end
end
