require 'rails_helper'

RSpec.feature 'Marking a development as agreed', type: :feature do
  scenario 'successfully' do
    development = create(:development, state: 'draft')
    login
    click_link 'AP/2019/1234'
    expect(page).to have_content 'Draft'
    click_link 'Mark as agreed'
    click_button 'Mark as agreed'
    expect(page).to have_content 'Development marked as agreed'
    development.reload
    expect(development.state).to eq('agreed')
  end
end
