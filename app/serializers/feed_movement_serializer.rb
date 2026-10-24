class FeedMovementSerializer < ActiveModel::Serializer
  attributes :id, :movement_type, :quantity, :occurred_on, :created_at, :updated_at

  attribute :value, if: :entry?
  attribute :reason, if: :exit?

  def entry?
    object.entry?
  end

  def exit?
    object.exit?
  end
end
