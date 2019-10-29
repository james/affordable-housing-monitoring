require 'rails_helper'

RSpec.feature 'Creating dwellings', type: :feature do
  scenario 'successfully adding a dwelling to a new development' do
    login
    development = create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Add a new dwelling'
    select 'open', from: 'Tenure'
    fill_in 'Number of habitable rooms', with: 2
    fill_in 'Number of bedrooms', with: 1
    click_button 'Add dwelling'
    expect(page).to have_content('Dwelling successfully added')
    dwelling = development.dwellings.first
    expect(dwelling.tenure).to eq('open')
    expect(dwelling.habitable_rooms).to eq(2)
    expect(dwelling.bedrooms).to eq(1)
  end

  scenario 'validation error adding a dwelling' do
    login
    create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Add a new dwelling'
    select 'open', from: 'Tenure'
    fill_in 'Number of habitable rooms', with: ''
    fill_in 'Number of bedrooms', with: ''
    click_button 'Add dwelling'
    expect(page).to have_content("Habitable rooms can't be blank")
    expect(page).to have_content("Bedrooms can't be blank")
  end
end
