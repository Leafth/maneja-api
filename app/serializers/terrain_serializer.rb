class TerrainSerializer < ActiveModel::Serializer
  attributes :id, :name, :rest_days, :status, :created_at, :updated_at
end
