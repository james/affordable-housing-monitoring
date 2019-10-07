require 'rails_helper'

RSpec.feature 'Editing a development core details', type: :feature do
  scenario 'successfully' do
    login
    create(:development)
    visit developments_path
    click_link 'edit'
    fill_in 'Application number', with: 'AP/2019/1235'
    fill_in 'Site address', with: 'new 1 Site Address, London, SE1 1AA'
    fill_in 'Proposal', with: 'Build a building edited'
    click_button 'Save and continue'
    expect(page).to have_text('Development successfully saved')
    expect(page).to have_text('AP/2019/1235')
    expect(page).to have_text('new 1 Site Address, London, SE1 1AA')
    expect(page).to have_text('Build a building edited')
  end

  scenario 'unable to view if not logged in' do
    development = create(:development)
    visit edit_development_path(development)
    expect(current_path).to eq(new_user_session_path)
  end
end
