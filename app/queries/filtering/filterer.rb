module Filtering
  class Filterer
    class << self
      def call(scope:, filters:, definitions:)
        filters.reduce(scope) do |current_scope, (key, value)|
          next current_scope if value.blank?
          filter = definitions[key.to_sym]
          filter ? filter.call(current_scope, value) : current_scope
        end
      end
    end
  end
end
