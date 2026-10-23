module Occupations
  class Close
    class << self
      def call(occupation:)
        occupation.update!(ended_at: Time.current)
        occupation
      end
    end
  end
end
