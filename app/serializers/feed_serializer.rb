class FeedSerializer < ActiveModel::Serializer
  include FeedConsumptionAttributes

  attributes :id, :name, :stock_quantity
  attribute :daily_required_quantity, if: :include_consumption?
  attribute :days_remaining, if: :include_consumption?
  attribute :alert_level, if: :include_consumption?
  attributes :created_at, :updated_at
end
