require 'rails_helper'

RSpec.feature 'Editing a development core details', type: :feature do
  scenario 'on a new development' do
    login
    development = create(:development, state: 'draft')
    visit edit_development_path(development)
    click_button 'Delete development'
    expect(page).to have_content('Development deleted')
  end

  scenario 'on an agreed development' do
    login
    development = create(:development, state: 'agreed')
    visit edit_development_path(development)
    expect(page).to_not have_button('Delete development')
  end
end
