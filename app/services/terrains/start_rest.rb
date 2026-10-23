module Terrains
  class StartRest
    class << self
      def call(terrain:)
        if terrain.rest_days.zero?
          Terrains::Release.call(terrain:)
        else
          terrain.update!(status: :resting)
        end

        terrain
      end
    end
  end
end
