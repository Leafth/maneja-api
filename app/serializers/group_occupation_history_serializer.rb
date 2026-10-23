class GroupOccupationHistorySerializer < ActiveModel::Serializer
  attributes :id, :started_at, :ended_at

  belongs_to :terrain, serializer: TerrainSummarySerializer
end
