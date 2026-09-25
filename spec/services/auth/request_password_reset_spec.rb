require 'rails_helper'

RSpec.describe Auth::RequestPasswordReset do
  describe '.call' do
    it "generates password reset data for the user" do
      user = create(:user)
      described_class.call(email: user.email)
      user.reload
      expect(user.reset_password_token).to be_present
      expect(user.reset_password_sent_at).to be_present
    end

    it "sends a six-digit recovery code to the user" do
      user = create(:user)
      described_class.call(email: user.email)
      email = ActionMailer::Base.deliveries.last
      body =
        if email.text_part
          email.text_part.body.decoded
        else
          email.body.decoded
        end
      expect(body).to match(/\b\d{6}\b/)
    end

    it "sends a password reset instructions to the user" do
      user = create(:user)
      expect { described_class.call(email: user.email) }.to change { ActionMailer::Base.deliveries.count }.by(1)
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include(user.email)
    end

    it "does not generate password reset data for a non-existent user" do
      expect { described_class.call(email: Faker::Internet.unique.email) }.not_to change(ActionMailer::Base.deliveries, :count)
    end
  end
end
