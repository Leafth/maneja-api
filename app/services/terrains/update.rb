module Terrains
  class Update
    class << self
      def call(id:, attributes:)
        terrain = Terrains::Find.call(id:)
        terrain.update!(attributes)
        terrain
      end
    end
  end
end
