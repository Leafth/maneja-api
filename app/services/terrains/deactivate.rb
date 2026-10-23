module Terrains
  class Deactivate
    class << self
      def call(id:)
        ActiveRecord::Base.transaction do
          terrain = Terrain.active.lock.find(id)
          validate_deactivation!(terrain)
          terrain.soft_delete!
          terrain
        end
      end

      private

      def validate_deactivation!(terrain)
        return unless terrain.occupations.active.exists?

        raise Occupations::DeactivationError, I18n.t("occupations.terrain_occupied")
      end
    end
  end
end
