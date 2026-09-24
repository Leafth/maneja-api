require 'rails_helper'

RSpec.describe Auth::RefreshSession do
  describe '.call' do
    it "refreshes an active session" do
      user = create(:user)
      tokens = Auth::CreateSession.call(user:)
      old_refresh_token = tokens[:refresh_token]
      result = described_class.call(refresh_token: old_refresh_token)
      expect(result[:access_token]).to be_present
      expect(result[:refresh_token]).to be_present
    end

    it "rotates the refresh token" do
      user = create(:user)
      tokens = Auth::CreateSession.call(user:)
      old_refresh_token = tokens[:refresh_token]
      result = described_class.call(refresh_token: old_refresh_token)
      expect(result[:refresh_token]).not_to eq(old_refresh_token)
    end

    it "updates the stored refresh token digest" do
      user = create(:user)
      tokens = Auth::CreateSession.call(user:)
      old_refresh_token = tokens[:refresh_token]
      session = user.sessions.last
      old_digest = session.refresh_token_digest
      result = described_class.call(refresh_token: old_refresh_token)
      expect(session.reload.refresh_token_digest).not_to eq(old_digest)
      expect(session.refresh_token_digest).not_to eq(old_digest)
      expect(session.refresh_token_digest).to eq(Auth::RefreshToken.digest(result[:refresh_token]))
    end

    it "keeps the same session" do
      user = create(:user)
      tokens = Auth::CreateSession.call(user:)
      session = user.sessions.last
      result = described_class.call(refresh_token: tokens[:refresh_token])
      payload = Auth::AccessToken.decode(result[:access_token])
      expect(payload[:sub]).to eq(user.id)
      expect(payload[:sid]).to eq(session.id)
      expect(user.sessions.count).to eq(1)
    end

    it "invalidates the previous refresh token" do
      user = create(:user)
      tokens = Auth::CreateSession.call(user:)
      old_refresh_token = tokens[:refresh_token]
      described_class.call(refresh_token: old_refresh_token)
      expect {
        described_class.call(refresh_token: old_refresh_token)
      }.to raise_error(AuthenticationError)
    end

    it "raises an authentication error for a invalid refresh token" do
      expect {
        described_class.call(refresh_token: "invalid-refresh-token")
      }.to raise_error(AuthenticationError, I18n.t("errors.authentication.expired_token"))
    end

    it "does not refresh an expired session" do
      refresh_token = Auth::RefreshToken.generate
      create(:session, :expired, refresh_token_digest: Auth::RefreshToken.digest(refresh_token))
      expect {
        described_class.call(refresh_token: refresh_token)
      }.to raise_error(AuthenticationError)
    end

    it "does not refresh a revoked session" do
      refresh_token = Auth::RefreshToken.generate
      create(:session, :revoked, refresh_token_digest: Auth::RefreshToken.digest(refresh_token))
      expect {
        described_class.call(refresh_token: refresh_token)
      }.to raise_error(AuthenticationError)
    end

    it "does not extend the session expiration date" do
      user = create(:user)
      tokens = Auth::CreateSession.call(user:)
      session = user.sessions.last
      old_expires_at = session.expires_at
      described_class.call(refresh_token: tokens[:refresh_token])
      expect(session.reload.expires_at).to eq(old_expires_at)
    end
  end
end
