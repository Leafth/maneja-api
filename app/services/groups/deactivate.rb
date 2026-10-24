module Groups
  class Deactivate
    class << self
      def call(user:, id:)
        ActiveRecord::Base.transaction do
          group = user.groups.active.lock.find(id)
          occupation = group.occupations.active.lock.first
          close_occupation(user:, occupation:) if occupation
          group.soft_delete!
          group
        end
      end

      private

      def close_occupation(user:, occupation:)
        terrain = user.terrains.lock.find(occupation.terrain_id)
        Occupations::Close.call(occupation:)
        Terrains::StartRest.call(terrain:)
      end
    end
  end
end
