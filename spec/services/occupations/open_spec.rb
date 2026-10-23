require 'rails_helper'

RSpec.describe Occupations::Open, type: :service do
  describe '.call' do
    let(:group) { create(:group) }
    let(:terrain) { create(:terrain) }

    it 'creates an occupation' do
      expect {
        described_class.call(group:, terrain:)
      }.to change(Occupation, :count).by(1)
    end

    it "returns the created occupation" do
      occupation = described_class.call(group:, terrain:)
      expect(occupation).to be_persisted
      expect(occupation).to have_attributes(group:, terrain:, ended_at: nil)
      expect(occupation.started_at).to be_present
    end
  end
end
