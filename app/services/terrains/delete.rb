module Terrains
  class Delete
    class << self
      def call(id:)
        terrain = Terrains::Find.call(id:)
        terrain.soft_delete!
        terrain
      end
    end
  end
end
