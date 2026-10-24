class FeedMovementSerializer < ActiveModel::Serializer
  attribute :id
  attribute :feed_id, if: :include_feed_id?
  attributes :movement_type, :quantity
  attribute :value, if: :entry?
  attribute :reason, if: :exit?
  attributes :occurred_on, :created_at, :updated_at

  def include_feed_id? = instance_options[:include_feed_id]
  def entry? = object.entry?
  def exit? = object.exit?
end
