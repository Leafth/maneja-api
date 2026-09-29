module Sorting
  class Sorter
    DIRECTIONS = %w[asc desc].freeze

    class << self
      def call(scope:, sort:, direction:, allowed:, default:)
        column = allowed[sort&.to_sym]
        return scope.order(default) unless column
        scope.order(column => normalize_direction(direction))
      end

      private

      def normalize_direction(direction)
        value = direction.to_s.downcase
        DIRECTIONS.include?(value) ? value : "asc"
      end
    end
  end
end
