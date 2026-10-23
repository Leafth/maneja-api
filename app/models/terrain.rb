class Terrain < ApplicationRecord
  has_many :occupations, dependent: :restrict_with_error

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

  def current_occupation
    occupations.active.first
  end

  def current_group
    current_occupation&.group
  end

  def last_occupation
    occupations.finished.order(ended_at: :desc).first
  end

  def last_group
    last_occupation&.group
  end

  def remaining_rest_days
    return 0 unless resting?

    occupation = last_occupation
    return 0 unless occupation

    elapsed_days = (Date.current - occupation.ended_at.to_date).to_i

    [ rest_days - elapsed_days, 0 ].max
  end

  def days_free
    return 0 unless available?

    occupation = last_occupation

    return (Date.current - created_at.to_date).to_i unless occupation

    (Date.current - occupation.ended_at.to_date).to_i
  end

  def rest_completed?
    return false unless resting?

    occupation = last_occupation
    return false unless occupation
    occupation.ended_at.to_date + rest_days <= Date.current
  end
end
