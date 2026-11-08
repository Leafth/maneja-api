class FeedingSerializer < ActiveModel::Serializer
  attributes :id, :group_id, :feed_id, :quantity, :occurred_at, :created_at, :updated_at
end
