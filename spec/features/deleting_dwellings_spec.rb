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
    click_button 'Delete dwelling'
    expect(page).to have_content('Dwelling deleted')
    development.reload
    expect(development.dwellings.count).to eq(0)
  end
end
