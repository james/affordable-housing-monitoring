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
    expect(page).to_not have_content('Changelog')
    select 'social', from: 'Tenure'
    fill_in 'Number of habitable rooms', with: 3
    fill_in 'Number of bedrooms', with: 2
    click_button 'Save dwelling'
    expect(page).to have_content('Dwelling successfully saved')
    dwelling.reload
    expect(dwelling.tenure).to eq('social')
    expect(dwelling.habitable_rooms).to eq(3)
    expect(dwelling.bedrooms).to eq(2)
    expect(development.audits.count).to eq(0)
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

  scenario 'successfully editing a dwelling on an agreed development' do
    user = login
    development = create(:development)
    dwelling = create(:dwelling, development: development)
    development.agree!
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Edit'
    select 'social', from: 'Tenure'
    fill_in 'Number of habitable rooms', with: 3
    fill_in 'Number of bedrooms', with: 2
    fill_in 'Changelog', with: 'Testing changelog'
    click_button 'Save dwelling'
    expect(page).to have_content('Dwelling successfully saved')
    dwelling.reload
    expect(dwelling.tenure).to eq('social')
    expect(dwelling.habitable_rooms).to eq(3)
    expect(dwelling.bedrooms).to eq(2)
    visit development_path(development)
    within '.changelog_row' do
      expect(page).to have_content('Dwelling updated')
      expect(page).to have_content('Tenure changed from "open" to "social"')
      expect(page).to have_content('Habitable rooms changed from "1" to "3"')
      expect(page).to have_content('Bedrooms changed from "1" to "2"')
      expect(page).to have_content('Testing changelog')
      expect(page).to have_content(user.email)
    end
  end

  scenario 'no changelog when required' do
    login
    development = create(:development)
    create(:dwelling, development: development)
    development.agree!
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Edit'
    select 'social', from: 'Tenure'
    fill_in 'Changelog', with: ''
    click_button 'Save dwelling'
    expect(page).to have_content("Audit comment Comment can't be blank")
  end
end
