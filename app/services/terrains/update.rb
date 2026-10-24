module Terrains
  class Update
    class << self
      def call(user:, id:, attributes:)
        terrain = Terrains::Find.call(user:, id:)
        terrain.update!(attributes)
        terrain
      end
    end
  end
end
