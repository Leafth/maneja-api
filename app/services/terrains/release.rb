module Terrains
  class Release
    class << self
      def call(terrain:)
        terrain.update!(status: :available)
        terrain
      end
    end
  end
end
