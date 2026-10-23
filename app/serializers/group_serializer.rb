class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :animal_count, :created_at, :updated_at

  belongs_to :current_terrain, serializer: TerrainSummarySerializer
end
