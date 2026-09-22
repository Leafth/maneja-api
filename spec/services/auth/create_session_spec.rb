require 'rails_helper'

RSpec.describe Auth::CreateSession do
  describe '.call' do
    it "creates a session for the user" do
      user = create(:user)
      expect { described_class.call(user:) }.to change(Session, :count).by(1)
      expect(Session.last.user).to eq(user)
    end

    it "stores only the refresh token digest in the session" do
      user = create(:user)
      result = described_class.call(user:)
      session = Session.last
      expect(session.refresh_token_digest).to eq(Auth::RefreshToken.digest(result[:refresh_token]))
    end

    it "creates an active session with an expiration date" do
      user = create(:user)
      described_class.call(user:)
      session = Session.last
      expect(session.expires_at).to be_future
      expect(session).to be_active
    end

    it "returns the access token and refresh token" do
      user = create(:user)
      result = described_class.call(user:)
      session = Session.last
      payload = Auth::AccessToken.decode(result[:access_token])
      expect(payload[:sub]).to eq(user.id)
      expect(payload[:sid]).to eq(session.id)
    end

    it "rolls back the session when access token generation fails" do
      user = create(:user)
      initial_count = Session.count
      allow(Auth::AccessToken).to receive(:encode).and_raise(StandardError)
      expect { described_class.call(user:) }.to raise_error(StandardError)
      expect(Session.count).to eq(initial_count)
    end
  end
end
