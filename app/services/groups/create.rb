module Groups
  class Create
    class << self
      def call(attributes:)
        Group.create!(attributes)
      end
    end
  end
end
