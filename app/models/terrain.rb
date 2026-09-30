class Terrain < ApplicationRecord
  enum :status, {
    available: "available",
    occupied: "occupied",
    resting: "resting"
  }

  validates :name, presence: true
  validates :rest_days, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  def deleted?
    deleted_at.present?
  end

  def soft_delete!
    update!(deleted_at: Time.current)
  end
end
