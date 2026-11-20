module FeedConsumption
  class AlertLevels
    LEVELS = {
      critical: 5,
      urgency: 15,
      attention: 30,
      info: Float::INFINITY
     }.freeze

    class << self
      def resolve(days_remaining)
        LEVELS.find do |_level, max_days|
          days_remaining <= max_days
        end.first.to_s
      end

      def priority(level)
        LEVELS.keys.index(level.to_sym)
      end
    end
  end
end
