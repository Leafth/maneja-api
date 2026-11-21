module Overview
  class Show
    class << self
      def call(user:)
        {
          herd: herd_summary(user),
          terrains: terrains_summary(user)
        }
      end

      private

      def herd_summary(user)
        groups = user.groups.active

        {
          groups: groups.count,
          animals: groups.sum(:animal_count)
        }
      end

      def terrains_summary(user)
        terrains = user.terrains.active

        {
          total: terrains.count,
          available: terrains.available.count,
          occupied: terrains.occupied.count,
          resting: terrains.resting.count
        }
      end
    end
  end
end
