require 'rails_helper'

RSpec.feature 'Editing a development core details', type: :feature do
  scenario 'successfully - application number' do
    login
    create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    find('a', text: 'Edit proposal', visible: false).click
    fill_in 'Application number', with: 'AP/2019/1235'
    click_button 'Save and continue'
    expect(page).to have_text('Development successfully saved')
    expect(page).to have_text('AP/2019/1235')
  end

  scenario 'successfully - site address' do
    login
    create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    find('a', text: 'Edit address', visible: false).click
    fill_in 'Site address', with: 'new 1 Site Address, London, SE1 1AA'
    click_button 'Save and continue'
    expect(page).to have_text('Development successfully saved')
    expect(page).to have_text('new 1 Site Address, London, SE1 1AA')
  end

  scenario 'successfully - proposal' do
    login
    create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    find('a', text: 'Edit proposal', visible: false).click
    fill_in 'Proposal', with: 'Build a building edited'
    click_button 'Save and continue'
    expect(page).to have_text('Development successfully saved')
    expect(page).to have_text('Build a building edited')
  end

  scenario 'new development should not create changelog' do
    login
    development = create(:development, state: 'draft')
    visit developments_path
    click_link 'AP/2019/1234'
    find('a', text: 'Edit proposal', visible: false).click
    expect(page).to_not have_content('Changelog')
    fill_in 'Proposal', with: 'Build a building edited'
    click_button 'Save and continue'
    development.reload
    expect(development.proposal).to eq('Build a building edited')
    expect(development.audits.count).to eq(0)
  end

  scenario 'agreed development should create changelog' do
    user = login
    create(:development, state: 'agreed', proposal: 'Build a building')
    visit developments_path
    click_link 'AP/2019/1234'
    find('a', text: 'Edit proposal', visible: false).click
    fill_in 'Proposal', with: 'Build a building edited'
    fill_in 'Changelog', with: 'Testing changelog'
    click_button 'Save and continue'
    within '.changelog_row' do
      expect(page).to have_content('proposal changed from "Build a building" to "Build a building edited"')
      expect(page).to have_content('Testing changelog')
      expect(page).to have_content(user.email)
    end
  end

  scenario 'with validation error' do
    login
    create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    find('a', text: 'Edit proposal', visible: false).click
    fill_in 'Application number', with: ''
    fill_in 'Site address', with: ''
    fill_in 'Proposal', with: ''
    click_button 'Save and continue'
    expect(page).to have_content("Application number can't be blank")
  end

  scenario 'no changelog when required' do
    login
    create(:development, state: 'agreed')
    visit developments_path
    click_link 'AP/2019/1234'
    find('a', text: 'Edit proposal', visible: false).click
    fill_in 'Proposal', with: 'Build a building edited'
    fill_in 'Changelog', with: ''
    click_button 'Save and continue'
    expect(page).to have_content("Audit comment Comment can't be blank")
  end

  scenario 'unable to view if not logged in' do
    development = create(:development)
    visit edit_development_path(development)
    expect(current_path).to eq(new_user_session_path)
  end
end
