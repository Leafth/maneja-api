module Occupations
  class Move
    class << self
      def call(group:, destination:)
        ActiveRecord::Base.transaction do
          group.lock!

          current_occupation = group.occupations.active.lock.first
          lock_terrains!(current_occupation, destination)

          MovementPolicy.validate!(group:, current_occupation:, destination:)

          close_current_occupation(current_occupation)

          occupation = Open.call(group:, terrain: destination)
          Terrains::Occupy.call(terrain: destination)

          occupation
        end
      end

      private

      def close_current_occupation(occupation)
        return unless occupation

        Close.call(occupation:)
        Terrains::StartRest.call(terrain: occupation.terrain)
      end

      def lock_terrains!(current_occupation, destination)
        terrains_ids = [ current_occupation&.terrain_id, destination.id ].compact.uniq.sort
        Terrain.where(id: terrains_ids).order(:id).lock.load
      end
    end
  end
end
