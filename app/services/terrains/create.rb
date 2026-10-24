module Terrains
  class Create
    class << self
      def call(user:, attributes:)
        user.terrains.create!(
          attributes.merge(status: :available, user:)
        )
      end
    end
  end
end
