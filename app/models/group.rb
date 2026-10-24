class Group < ApplicationRecord
  belongs_to :user

  has_many :occupations, dependent: :restrict_with_error

  validates :name, presence: true
  validates :animal_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

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

  def current_terrain
    current_occupation&.terrain
  end
end
