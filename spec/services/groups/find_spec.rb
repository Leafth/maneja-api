require 'rails_helper'

RSpec.describe Groups::Find, type: :service do
  describe '.call' do
    it 'returns an active group' do
      group = create(:group)
      result = described_class.call(id: group.id)
      expect(result).to eq(group)
    end

    it "raises an error when the group is deleted" do
      group = create(:group, :deleted)
      expect { described_class.call(id: group.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error when the group does not exist" do
      expect { described_class.call(id: SecureRandom.uuid) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
