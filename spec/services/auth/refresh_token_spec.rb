require 'rails_helper'
RSpec.describe Auth::RefreshToken do
  describe '.generate' do
    it "generates a new refresh token" do
      token = described_class.generate
      expect(token).to be_a(String)
      expect(token).to be_present
    end

    it "generates a unique refresh token" do
      first_token = described_class.generate
      second_token = described_class.generate
      expect(first_token).not_to eq(second_token)
    end
  end

  describe '.digest' do
    it "generates the same digest for the same token" do
      token = described_class.generate
      first_digest = described_class.digest(token)
      second_digest = described_class.digest(token)
      expect(first_digest).to eq(second_digest)
    end

    it "generates different digests for different tokens" do
      first_token = described_class.generate
      second_token = described_class.generate
      expect(described_class.digest(first_token)).not_to eq(described_class.digest(second_token))
    end
  end
end
