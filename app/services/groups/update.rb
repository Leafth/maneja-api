module Groups
  class Update
    class << self
      def call(user:, id:, attributes:)
        group = Groups::Find.call(user:, id:)
        group.update!(attributes)
        group
      end
    end
  end
end
