require 'rails_helper'

RSpec.describe Auth::RegisterUser do
  describe '.call' do
    let(:attributes) { attributes_for(:user) }

    it "creates a user" do
      expect {
        described_class.call(attributes:)
      }.to change(User, :count).by(1)
    end

    it "creates a session for the registered user" do
      result = described_class.call(attributes:)
      expect(result[:user].sessions.count).to eq(1)
    end

    it "returns the created user and tokens" do
      result = described_class.call(attributes:)
      expect(result[:user]).to be_a(User)
      expect(result[:user]).to be_persisted
      expect(result[:tokens]).to include(access_token: be_present, refresh_token: be_present)
    end

    it "raises an error when the attributes are invalid" do
      expect {
        described_class.call(attributes: { email: nil })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "does not create a user when the attributes are invalid" do
      expect {
        described_class.call(attributes: { email: nil })
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(User.count).to eq(0)
    end

    it "rolls back the user when session creation fails" do
      allow(Auth::CreateSession).to receive(:call).and_raise(StandardError)
      expect {
        described_class.call(attributes:)
      }.to raise_error(StandardError)
      expect(User.count).to eq(0)
    end
  end
end
