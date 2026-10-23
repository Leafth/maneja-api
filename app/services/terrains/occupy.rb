module Terrains
  class Occupy
    class << self
      def call(terrain:)
        terrain.update!(status: :occupied)
        terrain
      end
    end
  end
end
