class FeedRequirement < ApplicationRecord
  belongs_to :group
  belongs_to :feed

  validates :quantity_per_animal_kg, presence: true, numericality: { greater_than: 0 }
  validates :feed_id, uniqueness: { scope: :group_id }
end
