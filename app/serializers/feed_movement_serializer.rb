class FeedMovementSerializer < ActiveModel::Serializer
  attributes :id, :feed_id, :movement_type, :quantity, :value, :reason, :occurred_on, :created_at, :updated_at
end
