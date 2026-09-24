require 'rails_helper'

RSpec.describe Auth::AuthenticateUser do
  describe '.call' do
    it "authenticates a user with valid credentials" do
      user = create(:user)
      tokens = { access: "access_token", refresh: "refresh_token" }
      allow(Auth::CreateSession).to receive(:call).with(user:).and_return(tokens)
      result = described_class.call(email: user.email, password: user.password)
      expect(result).to eq(tokens)
    end

    it "creates a session for the authenticated user" do
      user = create(:user)
      allow(Auth::CreateSession).to receive(:call).with(user:).and_return({})
      described_class.call(email: user.email, password: user.password)
      expect(Auth::CreateSession).to have_received(:call).with(user:)
    end

    it "raises an authentication error when the email does not exist" do
      expect {
        described_class.call(email: Faker::Internet.email, password: Faker::Internet.password(min_length: 8))
      }.to raise_error(AuthenticationError)
    end

    it "raises an authentication error when the password is invalid" do
      user = create(:user)
      expect {
        described_class.call(email: user.email, password: "#{user.password}-invalid")
      }.to raise_error(AuthenticationError)
    end

    it "returns the same error message for an unknown email and an invalid password" do
      user = create(:user)
      unknown_email_error = capture_error_message do
        described_class.call(email: Faker::Internet.email, password: user.password)
      end
      invalid_password_error = capture_error_message do
        described_class.call(email: user.email, password: "#{user.password}-invalid")
      end
      expect(unknown_email_error).to eq(invalid_password_error)
    end
  end

  def capture_error_message
    yield
  rescue AuthenticationError => e
    e.message
  end
end
