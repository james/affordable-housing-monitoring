require 'rails_helper'

RSpec.feature 'Creating developments', type: :feature do
  scenario 'successfully' do
    login
    click_link 'Add a new development'
    fill_in 'Application number', with: 'AP/2019/1234'
    fill_in 'Site address', with: '1 Site Address, London, SE1 1AA'
    fill_in 'Proposal', with: 'Build a building'
    click_button 'Save and continue'
    expect(page).to have_text('Development successfully created')
    expect(page).to have_text('AP/2019/1234')
    expect(page).to have_text('1 Site Address, London, SE1 1AA')
    expect(page).to have_text('Build a building')
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
    visit new_development_path
    expect(current_path).to eq(new_user_session_path)
  end
end
