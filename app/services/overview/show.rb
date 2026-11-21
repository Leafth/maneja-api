module Overview
  class Show
    class << self
      def call(user:)
        {
          herd: herd_summary(user)
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
    end
  end
end
