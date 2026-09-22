require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'validations' do
    it "is valid with valid attributes" do
      session = build(:session)
      expect(session).to be_valid
    end

    it "is not valid without a refresh token digest" do
      session = build(:session, refresh_token_digest: nil)
      expect(session).to_not be_valid
      expect(session.errors[:refresh_token_digest]).to be_present
    end

    it 'is not valid without an expiration date' do
      session = build(:session, expires_at: nil)
      expect(session).to_not be_valid
      expect(session.errors[:expires_at]).to be_present
    end
  end

  describe '#expired?' do
    it "returns true when the session has expired" do
      session = build(:session, :expired)
      expect(session.expired?).to be true
    end

    it 'returns false when the session has not expired' do
      session = build(:session)
      expect(session.expired?).to be false
    end
  end

  describe '#revoked?' do
    it "returns true when the session has been revoked" do
      session = build(:session, :revoked)
      expect(session.revoked?).to be true
    end

    it 'returns false when the session has not been revoked' do
      session = build(:session)
      expect(session.revoked?).to be false
    end
  end

  describe '#active?' do
    it "returns true when the session is active" do
      session = build(:session)
      expect(session.active?).to be true
    end

    it 'returns false when the session is expired' do
      session = build(:session, :expired)
      expect(session.active?).to be false
    end

    it 'returns false when the session is revoked' do
      session = build(:session, :revoked)
      expect(session.active?).to be false
    end
  end

  describe '#revoke!' do
    it "revokes the session" do
      session = create(:session)
      session.revoke!
      expect(session.reload.revoked?).to be true
    end
  end

  describe '.active' do
    it "returns active sessions" do
      active_session = create(:session)
      create(:session, :expired)
      create(:session, :revoked)

      expect(described_class.active).to contain_exactly(active_session)
    end
  end
end
