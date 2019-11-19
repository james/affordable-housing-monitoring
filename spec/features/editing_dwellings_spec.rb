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
    expect(page).to_not have_content('Reason for changes to legal agreement')
    select 'social', from: 'Tenure'
    fill_in 'Reference ID', with: 'A10001'
    fill_in 'Number of habitable rooms', with: 3
    fill_in 'Number of bedrooms', with: 2
    click_button 'Save dwelling'
    expect(page).to have_content('Dwelling successfully saved')
    dwelling.reload
    expect(dwelling.reference_id).to eq('A10001')
    expect(dwelling.tenure).to eq('social')
    expect(dwelling.habitable_rooms).to eq(3)
    expect(dwelling.bedrooms).to eq(2)
    expect(development.audits.count).to eq(0)
  end

  scenario 'validation presence error editing a dwelling' do
    login
    development = create(:development)
    create(:dwelling, development: development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Edit'
    select 'social', from: 'Tenure'
    fill_in 'Reference ID', with: ''
    fill_in 'Number of habitable rooms', with: ''
    fill_in 'Number of bedrooms', with: ''
    click_button 'Save dwelling'
    expect(page).to have_content("Habitable rooms can't be blank")
    expect(page).to have_content("Bedrooms can't be blank")
    expect(page).to have_content("Reference ID can't be blank")
  end

  scenario 'validation uniqueness error editing a dwelling' do
    login
    development = create(:development)
    create(:dwelling, development: development, reference_id: 'A10001')
    create(:dwelling, development: development, reference_id: 'B10001')
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    within(:xpath, "//th[text() = 'B10001']/parent::tr") do
      click_link 'Edit'
    end
    select 'social', from: 'Tenure'
    fill_in 'Reference ID', with: 'A10001'
    fill_in 'Number of habitable rooms', with: 3
    fill_in 'Number of bedrooms', with: 2
    click_button 'Save dwelling'
    expect(page).to have_content('Reference ID has already been taken')
  end

  scenario 'successfully editing a dwelling on an agreed development' do
    user = login
    development = create(:development)
    dwelling = create(:dwelling, development: development, reference_id: 'B1')
    development.agree!
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Edit'
    select 'social', from: 'Tenure'
    fill_in 'Reference ID', with: 'A10001'
    fill_in 'Number of habitable rooms', with: 3
    fill_in 'Number of bedrooms', with: 2
    fill_in 'Reason for changes to legal agreement', with: 'Testing changelog'
    click_button 'Save dwelling'
    expect(page).to have_content('Dwelling successfully saved')
    dwelling.reload
    expect(dwelling.reference_id).to eq('A10001')
    expect(dwelling.tenure).to eq('social')
    expect(dwelling.habitable_rooms).to eq(3)
    expect(dwelling.bedrooms).to eq(2)
    visit development_path(development)
    within '.changelog_row' do
      expect(page).to have_content('Dwelling updated')
      expect(page).to have_content('Tenure changed from "open" to "social"')
      expect(page).to have_content('Habitable rooms changed from "1" to "3"')
      expect(page).to have_content('Bedrooms changed from "1" to "2"')
      expect(page).to have_content('Reference ID changed from "B1" to "A10001"')
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
    fill_in 'Reason for changes to legal agreement', with: ''
    click_button 'Save dwelling'
    expect(page).to have_content("Audit comment can't be blank")
  end
end
