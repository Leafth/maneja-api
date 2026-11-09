class FeedingSerializer < ActiveModel::Serializer
  attribute :id
  attribute :group_id, if: :include_group_id?
  attributes :feed_id, :quantity, :occurred_at, :created_at, :updated_at

  def include_group_id?
    instance_options[:include_group_id]
  end
end
