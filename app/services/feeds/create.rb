module Feeds
  class Create
    class << self
      def call(user:, name:, initial_stock_quantity:)
        user.feeds.create!(name:, stock_quantity: initial_stock_quantity)
      end
    end
  end
end
