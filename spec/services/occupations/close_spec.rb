require 'rails_helper'

RSpec.describe Occupations::Close, type: :service do
  describe '.call' do
    it "closes the occupation" do
      occupation = create(:occupation)
      result = described_class.call(occupation: occupation)
      expect(result.ended_at).to be_present
      expect(result.finished?).to be true
    end

    it "persists the occupation end" do
      occupation = create(:occupation)
      described_class.call(occupation:)
      expect(occupation.reload.ended_at).to be_present
    end

    it "keeps the occupation persisted" do
      occupation = create(:occupation)
      expect { described_class.call(occupation:) }.not_to change(Occupation, :count)
    end
  end
end
