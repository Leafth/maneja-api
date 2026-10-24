module Occupations
  class Move
    class << self
      def call(user:, group:, destination:)
        ActiveRecord::Base.transaction do
          group = user.groups.lock.find(group.id)

          current_occupation = group.occupations.active.lock.first
          destination = lock_terrains!(user:, current_occupation:, destination:)

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

      def lock_terrains!(user:, current_occupation:, destination:)
        terrains_ids = [ current_occupation&.terrain_id, destination.id ].compact.uniq.sort
        terrains = user.terrains.order(:id).lock.find(terrains_ids)
        terrains.find { |terrain| terrain.id == destination.id }
      end
    end
  end
end
