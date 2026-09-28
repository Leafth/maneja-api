require 'rails_helper'

RSpec.describe Groups::Create, type: :service do
  describe '.call' do
    let(:attributes) { attributes_for(:group) }

    it "creates a group" do
      expect { described_class.call(attributes: attributes) }.to change(Group, :count).by(1)
    end

    it "returns the created group" do
      group = described_class.call(attributes: attributes)
      expect(group).to be_a(Group)
      expect(group).to be_persisted
      expect(group).to have_attributes(name: attributes[:name], animal_count: attributes[:animal_count])
    end

    it "raises an error when the attributes are invalid" do
      invalid_attributes = attributes.merge(name: nil)
      expect { described_class.call(attributes: invalid_attributes) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "does not create a group when the attributes are invalid" do
      invalid_attributes = attributes.merge(animal_count: -1)
      expect { described_class.call(attributes: invalid_attributes) }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Group.count).to eq(0)
    end
  end
end
