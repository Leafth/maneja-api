module Groups
  class Find
    class << self
      def call(id:)
        Group.active.find(id)
      end
    end
  end
end
