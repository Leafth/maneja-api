module Groups
  class Delete
    class << self
      def call(id:)
        group = Groups::Find.call(id:)
        group.soft_delete!
        group
      end
    end
  end
end
