module Occupations
  class MovementPolicy
    class << self
      def validate!(group:, current_occupation:, destination:)
        validate_group!(group)
        validate_destination!(destination)
        validate_same_terrain!(current_occupation, destination)
        validate_destination_status!(destination)

        true
      end

      private

      def validate_group!(group)
        return unless group.deleted?

        raise Occupations::MovementError, I18n.t("errors.occupations.inactive_group")
      end

      def validate_destination!(destination)
        return unless destination.deleted?

        raise Occupations::MovementError, I18n.t("errors.occupations.inactive_terrain")
      end

      def validate_same_terrain!(current_occupation, destination)
        return unless current_occupation&.terrain_id == destination.id

        raise Occupations::MovementError, I18n.t("errors.occupations.same_terrain")
      end

      def validate_destination_status!(destination)
        return unless destination.occupied?

        raise Occupations::MovementError, I18n.t("errors.occupations.terrain_occupied")
      end
    end
  end
end
