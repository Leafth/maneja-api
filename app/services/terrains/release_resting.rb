module Terrains
  class ReleaseResting
    class << self
      def call
        Terrain.resting.find_each do |terrain|
          next unless terrain.rest_completed?

          Terrains::Release.call(terrain:)
        end
      end
    end
  end
end
