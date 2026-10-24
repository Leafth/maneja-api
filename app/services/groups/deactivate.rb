module Groups
  class Deactivate
    class << self
      def call(user:, id:)
        ActiveRecord::Base.transaction do
          group = user.groups.active.lock.find(id)
          occupation = group.occupations.active.lock.first
          close_occupation(occupation) if occupation
          group.soft_delete!
          group
        end
      end

      private

      def close_occupation(occupation)
        occupation.terrain.lock!
        Occupations::Close.call(occupation:)
        Terrains::StartRest.call(terrain: occupation.terrain)
      end
    end
  end
end
