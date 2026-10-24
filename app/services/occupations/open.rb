module Occupations
  class Open
    class << self
      def call(group:, terrain:)
        raise ActiveRecord::RecordNotFound unless group.user_id == terrain.user_id

        Occupation.create!(
          group:,
          terrain:,
          started_at: Time.current,
        )
      end
    end
  end
end
