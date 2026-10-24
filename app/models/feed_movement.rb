class FeedMovement < ApplicationRecord
  belongs_to :feed

  enum :movement_type, {
    entry: "entry",
    exit: "exit"
  }, validate: true

  validates :movement_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :occurred_on, presence: true
end
