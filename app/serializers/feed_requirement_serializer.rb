class FeedRequirementSerializer < ActiveModel::Serializer
  attributes :id, :group_id, :feed_id, :quantity_per_animal_kg, :created_at, :updated_at
end
