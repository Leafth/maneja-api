class OccupationSerializer < ActiveModel::Serializer
  attributes :id, :started_at, :ended_at

  belongs_to :group, serializer: GroupSummarySerializer
  belongs_to :terrain, serializer: TerrainSummarySerializer
end
