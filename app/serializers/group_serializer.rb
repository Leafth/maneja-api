class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :animal_count, :created_at, :updated_at
end
