require 'rails_helper'

RSpec.describe Groups::Update, type: :service do
  describe '.call' do
    it "updates the group" do
      group = create(:group)
      result = described_class.call(id: group.id, attributes: { name: "New Name", animal_count: 50 })
      expect(result).to have_attributes(name: "New Name", animal_count: 50)
    end

    it "persists the changes" do
      group = create(:group)
      described_class.call(id: group.id, attributes: { name: "New Name" })
      expect(group.reload.name).to eq("New Name")
    end

    it "raises an error if the attributes are invalid" do
      group = create(:group)
      expect {
        described_class.call(id: group.id, attributes: { animal_count: -10 })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "raises an error if the group is deleted" do
      group = create(:group, :deleted)
      expect {
        described_class.call(id: group.id, attributes: { name: "New Name" })
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises an error if the group is not found" do
      expect {
        described_class.call(id: 999, attributes: { name: "New Name" })
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
