module Terrains
  class Create
    class << self
      def call(attributes:)
        Terrain.create!(
          attributes.merge(status: :available)
        )
      end
    end
  end
end
