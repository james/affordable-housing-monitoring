require 'rails_helper'

RSpec.describe Development, type: :model do
  describe '#state' do
    it 'cannot be nil' do
      development = build(:development, state: nil)
      expect(development).to be_invalid
    end

    it 'cannot be blank' do
      development = build(:development, state: '')
      expect(development).to be_invalid
    end

    it 'cannot be an invalid state' do
      development = build(:development, state: 'something-weird')
      expect(development).to be_invalid
    end

    it 'can be a valid state' do
      development = build(:development, state: 'draft')
      expect(development).to be_valid
    end
  end

  describe '#completion_response_needed?' do
    let!(:development) { create(:development) }
    let!(:dwelling) { create(:dwelling, development: development, tenure: 'intermediate') }
    let!(:open_dwelling) { create(:dwelling, development: development, tenure: 'open', address: '') }

    it 'should be false if status is not completed' do
      development.update(state: 'draft')
      expect(development.completion_response_needed?).to eq(false)
    end

    it 'should be true if status is completed and any dwellings do not have address or registered provider' do
      development.update(state: 'completed')
      dwelling.update(address: '', registered_provider: nil)
      development.reload

      expect(development.completion_response_needed?).to eq(true)
    end

    it 'should be false if status is completed and all dwellings have address and registered provider' do
      development.update(state: 'completed')
      dwelling.update(address: 'present', registered_provider: create(:registered_provider))
      development.reload

      expect(development.completion_response_needed?).to eq(false)
    end
  end
end
