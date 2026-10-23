class TerrainOccupationHistorySerializer < ActiveModel::Serializer
  attributes :id, :started_at, :ended_at

  belongs_to :group, serializer: GroupSummarySerializer
end
