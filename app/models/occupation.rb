class Occupation < ApplicationRecord
  belongs_to :group
  belongs_to :terrain

  validates :started_at, presence: true
  validate :ended_at_not_before_started_at

  scope :active, -> { where(ended_at: nil) }
  scope :finished, -> { where.not(ended_at: nil) }

  def active?
    ended_at.nil?
  end

  def finished?
    !active?
  end

  private

  def ended_at_not_before_started_at
    return if ended_at.blank? || started_at.blank?
    return if ended_at >= started_at

    errors.add(:ended_at, :greater_than_or_equal_to, count: started_at)
  end
end
