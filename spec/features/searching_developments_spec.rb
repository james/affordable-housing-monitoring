require 'rails_helper'

RSpec.feature 'Searching developments', type: :feature do
  before do
    development1 = create(:development_with_number, application_number: 'APP1', proposal: 'Build development', site_address: '1 Old Street')
    create(:development_with_number, application_number: 'APP2', proposal: 'Build houses', site_address: '1 New Street', developer: 'Property Developer')
    create(:dwelling, development: development1, address: 'Flat 1, Flower House, SE1 1AA')
  end

  scenario 'by application number' do
    login
    fill_in 'Search', with: 'App2'
    click_button 'Search'
    expect(page).to have_content('Build houses')
    expect(page).to_not have_content('Build development')
  end

  scenario 'by proposal' do
    login
    fill_in 'Search', with: 'build development'
    click_button 'Search'
    expect(page).to have_content('APP1')
    expect(page).to_not have_content('APP2')
  end

  scenario 'by site address' do
    login
    fill_in 'Search', with: 'street Old'
    click_button 'Search'
    expect(page).to have_content('APP1')
    expect(page).to_not have_content('APP2')
  end

  scenario 'by developer' do
    login
    fill_in 'Search', with: 'Property Developer'
    click_button 'Search'
    expect(page).to have_content('APP2')
    expect(page).to_not have_content('APP1')
  end

  scenario 'by dwelling address' do
    login
    fill_in 'Search', with: 'Flower House'
    click_button 'Search'
    expect(page).to have_content('APP1')
    expect(page).to_not have_content('APP2')
  end
end
