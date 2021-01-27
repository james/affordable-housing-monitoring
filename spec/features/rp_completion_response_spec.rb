require 'rails_helper'

RSpec.feature 'Developer filling out a completion response', type: :feature do
  before do
    @registered_provider1 = create(:registered_provider, name: 'RPOne')
    @registered_provider2 = create(:registered_provider, name: 'RPTwo')
    @development = create(:development, state: 'partially_confirmed_completed')
    Dwelling.without_auditing do
      create(:dwelling, development: @development, tenure: 'open')
      @intermediate_dwelling = create(:dwelling, development: @development, tenure: 'intermediate', address: '1 address', uprn: 'uprn1', registered_provider: @registered_provider1)
      @social_dwelling = create(:dwelling, development: @development, tenure: 'social', address: '2 address', uprn: 'uprn2', registered_provider: @registered_provider1)
    end
  end

  scenario 'successfully and completely' do
    visit rp_response_form_development_path(@development, rpak: @development.rp_access_key)
    expect(page).to_not have_content('Open')

    within ".dwelling_#{@intermediate_dwelling.id}" do
      fill_in 'Your ID', with: 'RP1'
    end

    within ".dwelling_#{@social_dwelling.id}" do
      fill_in 'Your ID', with: 'RP2'
    end

    click_button 'Submit response'

    expect(page).to have_content('Your development information has been submitted')

    @intermediate_dwelling.reload
    @social_dwelling.reload
    expect(@intermediate_dwelling.rp_internal_id).to eq('RP1')
    expect(@social_dwelling.rp_internal_id).to eq('RP2')

    @development.reload
    expect(@development.state).to eq('confirmed_completed')
  end

  scenario 'with wrong access key' do
    expect do
      visit completion_response_form_development_path(@development, rpak: 'wild-guess')
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end
