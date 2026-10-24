module Feeds
  class Create
    class << self
      def call(name:, initial_stock_quantity:)
        Feed.create!(name:, stock_quantity: initial_stock_quantity)
      end
    end
  end
end
