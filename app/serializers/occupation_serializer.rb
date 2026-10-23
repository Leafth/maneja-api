class OccupationSerializer < ActiveModel::Serializer
  attributes :id, :group_id, :terrain_id, :started_at, :ended_at
end
