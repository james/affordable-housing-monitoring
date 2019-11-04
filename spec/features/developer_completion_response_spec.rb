require 'rails_helper'

RSpec.feature 'Developer filling out a completion response', type: :feature do
  before do
    @registered_provider1 = create(:registered_provider, name: 'RPOne')
    @registered_provider2 = create(:registered_provider, name: 'RPTwo')
    @development = create(:development, state: 'completed')
    Dwelling.without_auditing do
      create(:dwelling, development: @development, tenure: 'open')
      @intermediate_dwelling = create(:dwelling, development: @development, tenure: 'intermediate')
      @social_dwelling = create(:dwelling, development: @development, tenure: 'social')
    end
  end

  scenario 'successfully and completely' do
    visit completion_response_form_development_path(@development)
    expect(page).to_not have_content('Open')

    within ".dwelling_#{@intermediate_dwelling.id}" do
      fill_in 'Address', with: '1 Newbuild House'
      select 'RPOne', from: 'Registered provider'
    end

    within ".dwelling_#{@social_dwelling.id}" do
      fill_in 'Address', with: '2 Newbuild House'
      select 'RPTwo', from: 'Registered provider'
    end

    click_button 'Submit response'

    expect(page).to have_content('Your development information has been submitted')

    @intermediate_dwelling.reload
    @social_dwelling.reload
    expect(@intermediate_dwelling.address).to eq('1 Newbuild House')
    expect(@intermediate_dwelling.registered_provider).to eq(@registered_provider1)
    expect(@social_dwelling.address).to eq('2 Newbuild House')
    expect(@social_dwelling.registered_provider).to eq(@registered_provider2)
  end

  scenario 'successfully but incomplete' do
    visit completion_response_form_development_path(@development)

    within ".dwelling_#{@intermediate_dwelling.id}" do
      fill_in 'Address', with: '1 Newbuild House'
      select 'RPOne', from: 'Registered provider'
    end

    within ".dwelling_#{@social_dwelling.id}" do
      fill_in 'Address', with: ''
      select '', from: 'Registered provider'
    end

    click_button 'Submit response'

    expect(page).to have_content('Your changes have been saved')
    expect(page).to have_content('We still need more information from you')

    @intermediate_dwelling.reload
    expect(@intermediate_dwelling.address).to eq('1 Newbuild House')
    expect(@intermediate_dwelling.registered_provider).to eq(@registered_provider1)
  end
end
