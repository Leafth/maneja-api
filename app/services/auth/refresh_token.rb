module Auth
  class RefreshToken
    class << self
      def generate
        SecureRandom.urlsafe_base64(64)
      end

      def digest(token)
        Digest::SHA256.hexdigest(token)
      end
    end
  end
end
