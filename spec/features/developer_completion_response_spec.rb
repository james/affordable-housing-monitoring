require 'rails_helper'

RSpec.feature 'Developer filling out a completion response', type: :feature do
  before do
    @registered_provider1 = create(:registered_provider, name: 'RPOne')
    @registered_provider2 = create(:registered_provider, name: 'RPTwo')
    @development = create(:development, state: 'unconfirmed_completed')
    Dwelling.without_auditing do
      create(:dwelling, development: @development, tenure: 'open')
      @intermediate_dwelling = create(:dwelling, development: @development, tenure: 'intermediate')
      @social_dwelling = create(:dwelling, development: @development, tenure: 'social')
    end
  end

  scenario 'successfully and completely' do
    visit completion_response_form_development_path(@development, dak: @development.developer_access_key)
    expect(page).to_not have_content('Open')

    within ".dwelling_#{@intermediate_dwelling.id}" do
      fill_in 'Address', with: '1 Newbuild House'
      fill_in 'UPRN', with: 'uprn1'
      select 'RPOne', from: 'Registered provider'
      select 'London Living Rent', from: 'Tenure product'
    end

    within ".dwelling_#{@social_dwelling.id}" do
      fill_in 'Address', with: '2 Newbuild House'
      fill_in 'UPRN', with: 'uprn2'
      select 'RPTwo', from: 'Registered provider'
      select 'Social rent', from: 'Tenure product'
    end

    click_button 'Submit response'

    expect(page).to have_content('Your development information has been submitted')

    @intermediate_dwelling.reload
    @social_dwelling.reload
    expect(@intermediate_dwelling.address).to eq('1 Newbuild House')
    expect(@intermediate_dwelling.uprn).to eq('uprn1')
    expect(@intermediate_dwelling.registered_provider).to eq(@registered_provider1)
    expect(@intermediate_dwelling.tenure_product).to eq('London Living Rent')
    expect(@social_dwelling.address).to eq('2 Newbuild House')
    expect(@social_dwelling.uprn).to eq('uprn2')
    expect(@social_dwelling.registered_provider).to eq(@registered_provider2)
    expect(@social_dwelling.tenure_product).to eq('Social rent')

    @development.reload
    expect(@development.state).to eq('partially_confirmed_completed')
  end

  scenario 'successfully but incomplete' do
    visit completion_response_form_development_path(@development, dak: @development.developer_access_key)

    within ".dwelling_#{@intermediate_dwelling.id}" do
      fill_in 'Address', with: '1 Newbuild House'
      fill_in 'UPRN', with: 'uprn1'
      select 'RPOne', from: 'Registered provider'
    end

    within ".dwelling_#{@social_dwelling.id}" do
      fill_in 'Address', with: ''
      fill_in 'UPRN', with: ''
      select '', from: 'Registered provider'
    end

    click_button 'Submit response'

    expect(page).to have_content('Your changes have been saved')
    expect(page).to have_content('We still need more information from you')

    @intermediate_dwelling.reload
    expect(@intermediate_dwelling.address).to eq('1 Newbuild House')
    expect(@intermediate_dwelling.uprn).to eq('uprn1')
    expect(@intermediate_dwelling.registered_provider).to eq(@registered_provider1)

    @development.reload
    expect(@development.state).to eq('unconfirmed_completed')
  end

  scenario 'with wrong access key' do
    expect do
      visit completion_response_form_development_path(@development, dak: 'wild-guess')
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  scenario 'development is not in a completed state' do
    @development.update!(state: 'started')
    expect do
      visit completion_response_form_development_path(@development, dak: @development.developer_access_key)
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  scenario 'response form has already been completed' do
    Dwelling.without_auditing do
      @intermediate_dwelling.update!(address: '1 address', registered_provider: @registered_provider1)
      @social_dwelling.update!(address: '2 address', registered_provider: @registered_provider1)
    end
    visit completion_response_form_development_path(@development, dak: @development.developer_access_key)
    expect(page).to have_content('Your development information has been submitted')
  end
end
