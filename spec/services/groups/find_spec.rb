require 'rails_helper'

RSpec.describe Groups::Find, type: :service do
  describe '.call' do
    let(:user) { create(:user) }

    it 'returns an active group' do
      group = create(:group, user:)
      result = described_class.call(user: user, id: group.id)
      expect(result).to eq(group)
    end

    it "raises an error when the group is deleted" do
      group = create(:group, :deleted, user:)
      expect { described_class.call(user: user, id: group.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error when the group does not exist" do
      expect { described_class.call(user: user, id: SecureRandom.uuid) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error when the group belongs to another user" do
      group = create(:group)

      expect { described_class.call(user:, id: group.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
