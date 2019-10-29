require 'rails_helper'

RSpec.feature 'Editing dwellings', type: :feature do
  scenario 'successfully editing a dwelling on a new development' do
    login
    development = create(:development)
    dwelling = create(:dwelling, development: development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Edit'
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
    click_link 'Edit'
    select 'social', from: 'Tenure'
    fill_in 'Number of habitable rooms', with: ''
    fill_in 'Number of bedrooms', with: ''
    click_button 'Save dwelling'
    expect(page).to have_content("Habitable rooms can't be blank")
    expect(page).to have_content("Bedrooms can't be blank")
  end
end
