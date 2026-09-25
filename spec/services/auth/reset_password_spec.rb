require 'rails_helper'

RSpec.describe Auth::ResetPassword do
  describe '.call' do
    let (:user) { create(:user) }
    let (:new_password) { "novaSenha123" }
    let (:reset_token) do
      user.send_reset_password_instructions
      user.generate_token_for(:password_reset_verification)
    end

    it "resets the user password" do
      old_password = user.password
      described_class.call(reset_token:, password: new_password, password_confirmation: new_password)
      expect(user.reload.valid_password?(new_password)).to be(true)
      expect(user.valid_password?(old_password)).to be(false)
    end

    it "revokes the user's active sessions" do
      session = create(:session, user:)
      described_class.call(reset_token:, password: new_password, password_confirmation: new_password)
      expect(session.reload.revoked?).to be(true)
    end

    it "raises an authentication error for an invalid reset token" do
      expect {
        described_class.call(reset_token: "invalid_token", password: new_password, password_confirmation: new_password)
      }.to raise_error(AuthenticationError, I18n.t("errors.authentication.invalid_password_reset_token"))
    end

    it "raises an error when the new password is invalid" do
      expect {
        described_class.call(reset_token:, password: "123", password_confirmation: "123")
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "does not revoke sessions when the new password is invalid" do
      session = create(:session, user:)
      expect {
        described_class.call(reset_token:, password: "123", password_confirmation: "123")
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(session.reload.active?).to be(true)
    end

    it "does not allow the reset token to be reused" do
      described_class.call(reset_token:, password: new_password, password_confirmation: new_password)
      expect {
        described_class.call(reset_token:, password: "anotherPassword123", password_confirmation: "anotherPassword123")
      }.to raise_error(AuthenticationError, I18n.t("errors.authentication.invalid_password_reset_token"))
    end
  end
end
