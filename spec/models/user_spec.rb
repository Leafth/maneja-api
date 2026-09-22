require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is not valid without a name" do
      user = build(:user, name: nil)
      expect(user).to_not be_valid
      expect(user.errors[:name]).to be_present
    end

    it "is not valid without an email" do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
      expect(user.errors[:email]).to be_present
    end

    it "is not valid with an invalid email format" do
      invalid_emails = [ 'plainaddress', '@missingusername.com', 'username@' ]

      invalid_emails.each do |invalid_email|
        user = build(:user, email: invalid_email)
        expect(user).to_not be_valid
        expect(user.errors[:email]).to be_present
      end
    end

    it "does not allow duplicate emails" do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to be_present
    end

    it "requires a password with a minimum length of 8 characters" do
      user = build(:user, password: 'short', password_confirmation: 'short')
      expect(user).to_not be_valid
      expect(user.errors[:password]).to be_present
    end

    it "requires password confirmation to match the password" do
      user = build(:user, password_confirmation: Faker::Internet.password)
      expect(user).to_not be_valid
      expect(user.errors[:password_confirmation]).to be_present
    end

    describe 'associations' do
      it "destroy associated sessions when the user is destroyed" do
        user = create(:user)
        session = create(:session, user: user)
        user.destroy!
        expect(Session.find_by(id: session.id)).to be_nil
      end
    end
  end
end
