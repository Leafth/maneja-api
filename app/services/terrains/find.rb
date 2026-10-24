module Terrains
  class Find
    class << self
      def call(user:, id:)
        user.terrains.active.find(id)
      end
    end
  end
end
