module Groups
  class Find
    class << self
      def call(user:, id:)
        user.groups.active.find(id)
      end
    end
  end
end
