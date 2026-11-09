class Feeding < ApplicationRecord
  belongs_to :group
  belongs_to :feed

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  validates :occurred_at, presence: true
end
