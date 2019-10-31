require 'rails_helper'

RSpec.feature 'Deleting dwellings', type: :feature do
  scenario 'on a new development' do
    login
    development = create(:development)
    create(:dwelling, development: development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Edit'
    click_link 'Delete dwelling'
    expect(page).to_not have_content('Changelog')
    click_button 'Delete dwelling'
    expect(page).to have_content('Dwelling deleted')
    development.reload
    expect(development.dwellings.count).to eq(0)
  end

  scenario 'on an agreed development' do
    user = login
    development = create(:development)
    create(:dwelling, development: development)
    development.agree!
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage dwellings'
    click_link 'Edit'
    click_link 'Delete dwelling'
    fill_in 'Deletion reason', with: 'Deleted dwelling comment'
    click_button 'Delete dwelling'
    expect(page).to have_content('Dwelling deleted')
    visit development_path(development)
    within '.changelog_row' do
      expect(page).to have_content('Dwelling removed:')
      expect(page).to have_content('Deleted dwelling comment')
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
    click_link 'Delete dwelling'
    fill_in 'Deletion reason', with: ''
    click_button 'Delete dwelling'
    expect(page).to have_content("Audit comment Comment can't be blank")
  end
end
