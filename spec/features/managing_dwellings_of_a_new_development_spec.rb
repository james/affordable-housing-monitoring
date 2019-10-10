require 'rails_helper'

RSpec.feature 'Managing dwellings of a new development', type: :feature do
  scenario 'successfully adding a dwelling' do
    login
    development = create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
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
    select 'open', from: 'Tenure'
    fill_in 'Number of habitable rooms', with: ''
    fill_in 'Number of bedrooms', with: ''
    click_button 'Add dwelling'
    expect(page).to have_content("Habitable rooms can't be blank")
    expect(page).to have_content("Bedrooms can't be blank")
  end

  scenario 'successfully editing a dwelling' do
    login
    development = create(:development)
    dwelling = create(:dwelling, development: development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'edit'
    select 'social', from: 'Tenure'
    fill_in 'Number of habitable rooms', with: 3
    fill_in 'Number of bedrooms', with: 2
    click_button 'Save dwelling'
    expect(page).to have_content('Dwelling successfully saved')
    dwelling.reload
    expect(dwelling.tenure).to eq('social')
    expect(dwelling.habitable_rooms).to eq(3)
    expect(dwelling.bedrooms).to eq(2)
  end

  scenario 'validation error editing a dwelling' do
    login
    development = create(:development)
    create(:dwelling, development: development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'edit'
    select 'social', from: 'Tenure'
    fill_in 'Number of habitable rooms', with: ''
    fill_in 'Number of bedrooms', with: ''
    click_button 'Save dwelling'
    expect(page).to have_content("Habitable rooms can't be blank")
    expect(page).to have_content("Bedrooms can't be blank")
  end
end
