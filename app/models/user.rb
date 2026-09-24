class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  has_many :sessions, dependent: :destroy

  validates :name, presence: true

  protected

  def set_reset_password_token
    raw = nil
    encoded = nil

    loop do
      raw = SecureRandom.random_number(1_000_000).to_s.rjust(6, "0")
      encoded = Devise.token_generator.digest(self.class, :reset_password_token, raw)

      break unless self.class.exists?(reset_password_token: encoded)
    end

    self.reset_password_token = encoded
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)

    raw
  end
end
