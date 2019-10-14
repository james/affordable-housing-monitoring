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
end
