class FeedSerializer < ActiveModel::Serializer
  attributes :id, :name, :stock_quantity, :created_at, :updated_at
end
