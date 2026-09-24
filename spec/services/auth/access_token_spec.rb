require 'rails_helper'

RSpec.describe Auth::AccessToken do
  describe '.encode' do
    it "generates a JWT token with the correct payload" do
      user = create(:user)
      session = create(:session, user: user)
      token = described_class.encode(user:, session:)
      payload = described_class.decode(token)
      expect(payload[:sub]).to eq(user.id)
      expect(payload[:sid]).to eq(session.id)
      expect(payload[:iat]).to be_present
      expect(payload[:exp]).to be_present
    end
  end

  describe '.decode' do
    it "decodes a valid token" do
      user = create(:user)
      session = create(:session, user: user)
      token = described_class.encode(user:, session:)
      payload = described_class.decode(token)
      expect(payload[:sub]).to eq(user.id)
      expect(payload[:sid]).to eq(session.id)
    end

    it "raises an authentication error for an invalid token" do
      expect { described_class.decode('invalid_token') }.to raise_error(AuthenticationError, I18n.t('errors.authentication.invalid_token'))
    end

    it "raises an authentication error for an expired token" do
      user = create(:user)
      session = create(:session, user: user)
      allow(described_class).to receive(:expiration).and_return(-1.minute)
      token = described_class.encode(user:, session:)
      expect { described_class.decode(token) }.to raise_error(AuthenticationError, I18n.t('errors.authentication.expired_token'))
    end
  end
end
