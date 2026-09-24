class Session < ApplicationRecord
  belongs_to :user

  validates :refresh_token_digest, presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :active, -> { where(revoked_at: nil).where("expires_at > ?", Time.current) }

  def expired?
    expires_at < Time.current
  end

  def revoked?
    revoked_at.present?
  end

  def revoke!
    update(revoked_at: Time.current)
  end

  def active?
    !expired? && !revoked?
  end
end
