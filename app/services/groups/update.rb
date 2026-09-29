module Groups
  class Update
    class << self
      def call(id:, attributes:)
        group = Groups::Find.call(id:)
        group.update!(attributes)
        group
      end
    end
  end
end
