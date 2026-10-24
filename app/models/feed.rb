class Feed < ApplicationRecord
  has_many :feed_movements, dependent: :restrict_with_error
  validates :name, presence: true
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  def deleted?
    deleted_at.present?
  end

  def soft_delete!
    update!(deleted_at: Time.current)
  end
end
