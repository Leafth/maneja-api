module Terrains
  class Find
    class << self
      def call(id:)
        Terrain.active.find(id)
      end
    end
  end
end
