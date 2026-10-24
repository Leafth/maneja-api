class FeedMovement < ApplicationRecord
  belongs_to :feed

  enum :movement_type, {
    entry: "entry",
    exit: "exit"
  }, validate: true

  validates :movement_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: :entry?
  validates :reason, presence: true, if: :exit?
  validates :occurred_on, presence: true
end
