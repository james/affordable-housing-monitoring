require 'rails_helper'

RSpec.feature 'Creating schemes', type: :feature do
  scenario 'successfully from schemes index' do
    login
    click_link 'View all schemes'
    click_link 'Create a new scheme'
    fill_in 'Name', with: 'Dev name'
    fill_in 'Application number', with: 'AP/2019/1234'
    fill_in 'Site address', with: '1 Site Address, London, SE1 1AA'
    fill_in 'Proposal', with: 'Build many buildings'
    fill_in 'Developer', with: 'Developer name'
    click_button 'Save and continue'
    expect(page).to have_text('Scheme successfully created')
    expect(page).to have_text('Dev name')
    expect(page).to have_text('AP/2019/1234')
    expect(page).to have_text('1 Site Address, London, SE1 1AA')
    expect(page).to have_text('Build many buildings')
    expect(page).to have_text('Developer name')
  end

  scenario 'successfully from development' do
    pending
    login
    development = create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'create a new scheme'
    fill_in 'Name', with: 'Dev name'
    fill_in 'Application number', with: 'AP/2019/1234'
    fill_in 'Site address', with: '1 Site Address, London, SE1 1AA'
    fill_in 'Proposal', with: 'Build many buildings'
    fill_in 'Developer', with: 'Developer name'
    click_button 'Save and continue'
    expect(page).to have_text('Scheme successfully created')
    expect(page).to have_text('Dev name')
    expect(page).to have_text('AP/2019/1234')
    expect(page).to have_text('1 Site Address, London, SE1 1AA')
    expect(page).to have_text('Build many buildings')
    expect(development.scheme).to eq(Scheme.last)
  end

  scenario 'with validation error' do
    login
    click_link 'Add a new development'
    fill_in 'Application number', with: ''
    fill_in 'Site address', with: ''
    fill_in 'Proposal', with: ''
    click_button 'Save and continue'
    expect(page).to have_content("Application number can't be blank")
  end

  scenario 'unable to view if not logged in' do
    visit new_scheme_path
    expect(current_path).to eq(new_user_session_path)
  end
end
