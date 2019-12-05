require 'rails_helper'

RSpec.feature 'Editing a scheme core details', type: :feature do
  scenario 'successfully - name' do
    login
    create(:scheme)
    visit schemes_path
    click_link 'AP/2019/6789'
    find('a', text: 'Edit scheme proposal', visible: false).click
    fill_in 'Name', with: 'New scheme name'
    click_button 'Save and continue'
    expect(page).to have_text('Scheme successfully saved')
    expect(page).to have_text('New scheme name')
  end

  scenario 'successfully - site address' do
    login
    create(:scheme)
    visit schemes_path
    click_link 'AP/2019/6789'
    find('a', text: 'Edit site address', visible: false).click
    fill_in 'Site address', with: 'new 1 Site Address, London, SE1 1AA'
    click_button 'Save and continue'
    expect(page).to have_text('Scheme successfully saved')
    expect(page).to have_text('new 1 Site Address, London, SE1 1AA')
  end

  scenario 'successfully - proposal' do
    login
    create(:scheme)
    visit schemes_path
    click_link 'AP/2019/6789'
    find('a', text: 'Edit scheme proposal', visible: false).click
    fill_in 'Proposal', with: 'Build a building edited'
    click_button 'Save and continue'
    expect(page).to have_text('Scheme successfully saved')
    expect(page).to have_text('Build a building edited')
  end

  scenario 'successfully - developer' do
    login
    create(:scheme)
    visit schemes_path
    click_link 'AP/2019/6789'
    find('a', text: 'Edit developer name', visible: false).click
    fill_in 'Developer', with: 'New developer name'
    click_button 'Save and continue'
    expect(page).to have_text('Scheme successfully saved')
    expect(page).to have_text('New developer name')
  end

  scenario 'unable to view if not logged in' do
    scheme = create(:scheme)
    visit edit_scheme_path(scheme)
    expect(current_path).to eq(new_user_session_path)
  end
end
