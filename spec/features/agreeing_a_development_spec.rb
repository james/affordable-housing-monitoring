require 'rails_helper'

RSpec.feature 'Marking a development as agreed', type: :feature do
  scenario 'successfully' do
    development = create(:development, state: 'draft')
    login
    click_link 'AP/2019/1234'
    expect(page).to have_content 'Draft'
    click_link 'Mark as agreed'
    fill_in 'Day', with: '30'
    fill_in 'Month', with: '01'
    fill_in 'Year', with: '2019'
    click_button 'Mark as agreed'
    expect(page).to have_content 'Development marked as agreed'
    development.reload
    expect(development.state).to eq('agreed')
    expect(development.agreed_on).to eq('30/01/2019'.to_date)
  end
end
