require 'rails_helper'

RSpec.describe Auth::VerifyPasswordResetCode do
  describe '.call' do
    let (:user) { create(:user) }

    it "returns a temporary reset token for a valid recovery code" do
      code = user.send_reset_password_instructions
      reset_token = described_class.call(code: code)
      expect(reset_token).to be_present
    end

    it "generates a reset token associated with the user" do
      code = user.send_reset_password_instructions
      reset_token = described_class.call(code: code)
      recovered_user = User.find_by_token_for(:password_reset_verification, reset_token)
      expect(recovered_user).to eq(user)
    end

    it "raiser an authentication error for an invalid recovery code" do
      expect {
        described_class.call(code: "000000")
      }.to raise_error(AuthenticationError, I18n.t("errors.authentication.invalid_password_reset_code"))
    end

    it "raiser an authentication error for an expired recovery code" do
      code = user.send_reset_password_instructions
      user.update_column(:reset_password_sent_at, (Devise.reset_password_within + 1.minute).ago)
      expect {
        described_class.call(code: code)
      }.to raise_error(AuthenticationError, I18n.t("errors.authentication.invalid_password_reset_code"))
    end
  end
end
