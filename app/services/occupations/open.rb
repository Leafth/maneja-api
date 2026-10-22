module Occupations
  class Open
    class << self
      def call(group:, terrain:)
        Occupation.create!(
          group:,
          terrain:,
          started_at: Time.current,
        )
      end
    end
  end
end
