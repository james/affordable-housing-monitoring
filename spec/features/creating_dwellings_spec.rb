require 'rails_helper'

RSpec.feature 'Creating dwellings', type: :feature do
  scenario 'successfully adding a dwelling to a new development' do
    login
    development = create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Add a new dwelling'
    expect(page).to_not have_content('Reason for changes to legal agreement')
    select 'open', from: 'Tenure'
    fill_in 'Reference ID', with: 'A10001'
    fill_in 'Number of habitable rooms', with: 2
    fill_in 'Number of bedrooms', with: 1
    check 'Studio'
    click_button 'Add dwelling'
    expect(page).to have_content('Dwelling successfully added')
    dwelling = development.dwellings.first
    expect(dwelling.tenure).to eq('open')
    expect(dwelling.habitable_rooms).to eq(2)
    expect(dwelling.bedrooms).to eq(1)
    expect(dwelling.studio).to eq(true)
    expect(dwelling.reference_id).to eq('A10001')
    expect(development.audits.count).to eq(0)
  end

  scenario 'validation presence error adding a dwelling' do
    login
    create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Add a new dwelling'
    select 'open', from: 'Tenure'
    fill_in 'Reference ID', with: ''
    fill_in 'Number of habitable rooms', with: ''
    fill_in 'Number of bedrooms', with: ''
    click_button 'Add dwelling'
    expect(page).to have_content("Habitable rooms can't be blank")
    expect(page).to have_content("Bedrooms can't be blank")
    expect(page).to have_content("Reference ID can't be blank")
  end

  scenario 'validation uniqueness error adding a dwelling' do
    login
    development = create(:development)
    create(:dwelling, development: development, reference_id: 'A10001')
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Add a new dwelling'
    select 'open', from: 'Tenure'
    fill_in 'Reference ID', with: 'A10001'
    fill_in 'Number of habitable rooms', with: 2
    fill_in 'Number of bedrooms', with: 1
    click_button 'Add dwelling'
    expect(page).to have_content('Reference ID has already been taken')
  end

  scenario 'successfully adding a dwelling to an agreed development' do
    user = login
    development = create(:development, state: :agreed)
    create(:planning_application, development: development, application_number: 'AP/VARIATION')
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Add a new dwelling'
    select 'open', from: 'Tenure'
    fill_in 'Reference ID', with: 'A10001'
    fill_in 'Number of habitable rooms', with: 2
    fill_in 'Number of bedrooms', with: 1
    fill_in 'Reason for changes to legal agreement', with: 'Testing changelog'
    select 'AP/VARIATION', from: 'Planning application this change was agreed in'
    click_button 'Add dwelling'
    expect(page).to have_content('Dwelling successfully added')
    dwelling = development.dwellings.first
    expect(dwelling.tenure).to eq('open')
    expect(dwelling.habitable_rooms).to eq(2)
    expect(dwelling.bedrooms).to eq(1)
    expect(dwelling.reference_id).to eq('A10001')
    visit development_path(development)
    within '.changelog_row' do
      expect(page).to have_content('New dwelling added')
      expect(page).to have_content('Testing changelog')
      expect(page).to have_content(user.email)
      expect(page).to have_content('AP/VARIATION')
    end
  end

  scenario 'no changelog when required' do
    login
    create(:development, state: :agreed)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Add a new dwelling'
    fill_in 'Reason for changes to legal agreement', with: ''
    click_button 'Add dwelling'
    expect(page).to have_content("Audit comment can't be blank")
  end
end
