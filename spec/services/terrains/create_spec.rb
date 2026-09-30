require 'rails_helper'

RSpec.describe Terrains::Create, type: :service do
  describe '.call' do
    let(:attributes) { attributes_for(:terrain) }

    it "creates a terrain" do
      expect { described_class.call(attributes: attributes) }.to change(Terrain, :count).by(1)
    end

    it "returns the created terrain" do
      terrain = described_class.call(attributes: attributes)
      expect(terrain).to be_a(Terrain)
      expect(terrain).to be_persisted
      expect(terrain).to have_attributes(name: attributes[:name], rest_days: attributes[:rest_days])
      expect(terrain).to be_available
    end

    it "raises an error when the attributes are invalid" do
      invalid_attributes = attributes.merge(name: nil)
      expect { described_class.call(attributes: invalid_attributes) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "does not create a terrain when the attributes are invalid" do
      invalid_attributes = attributes.merge(rest_days: -1)
      expect { described_class.call(attributes: invalid_attributes) }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Terrain.count).to eq(0)
    end
  end
end
