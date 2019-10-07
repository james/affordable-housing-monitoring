require 'rails_helper'

RSpec.feature 'Signing in', type: :feature do
  scenario 'succesfully adding a development' do
    login
    click_link 'Add new development'
    fill_in 'Application number', with: 'AP/2019/1234'
    fill_in 'Site address', with: '1 Site Address, London, SE1 1AA'
    fill_in 'Proposal', with: 'Build a building'
    click_button 'Create Development'
    expect(page).to have_text('Development successfully created')
    expect(page).to have_text('AP/2019/1234')
    expect(page).to have_text('1 Site Address, London, SE1 1AA')
    expect(page).to have_text('Build a building')
  end

  scenario 'unable to view if not logged in' do
    visit new_development_path
    expect(current_path).to eq(new_user_session_path)
  end
end
