class FeedRequirementSerializer < ActiveModel::Serializer
  attribute :id
  attribute :group_id, if: :include_group_id?
  attributes :feed_id
  attribute :feed_name, if: :include_feed_details?
  attribute :quantity_per_animal_kg
  attribute :total_daily_kg, if: :include_total_daily_kg?
  attribute :days_remaining, if: :include_coverage?
  attribute :alert_level, if: :include_coverage?
  attributes :created_at, :updated_at

  def include_group_id? = instance_options[:include_group_id]

  def include_feed_details? = instance_options[:include_feed_details]

  def include_total_daily_kg? = instance_options[:include_total_daily_kg]

  def include_coverage? = instance_options[:include_coverage]

  def feed_name
    object.feed.name
  end

  def total_daily_kg
    object.daily_quantity
  end

  def days_remaining
    coverage[:days_remaining]
  end

  def alert_level
    coverage[:alert_level]
  end

  def coverage
    feed_data = consumption_snapshot[object.feed_id]

    return {} unless feed_data

    FeedConsumption::Coverage.call(
      stock_quantity: feed_data[:feed].stock_quantity,
      daily_required_quantity: feed_data[:daily_required_quantity]
    )
  end

  def consumption_snapshot
    instance_options[:consumption_snapshot] || {}
  end
end
