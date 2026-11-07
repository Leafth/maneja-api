class FeedRequirementSerializer < ActiveModel::Serializer
  attribute :id
  attribute :group_id, if: :include_group_id?
  attributes :feed_id, :quantity_per_animal_kg
  attribute :total_daily_kg, if: :include_total_daily_kg?
  attributes :created_at, :updated_at

  def include_group_id? = instance_options[:include_group_id]
  def include_total_daily_kg? = instance_options[:include_total_daily_kg]

  def total_daily_kg
    object.quantity_per_animal_kg * object.group.animal_count
  end
end
