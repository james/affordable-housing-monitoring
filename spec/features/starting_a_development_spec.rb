require 'rails_helper'

RSpec.feature 'Marking a development as started', type: :feature do
  scenario 'successfully' do
    development = create(:development, state: 'agreed')
    login
    click_link 'AP/2019/1234'
    expect(page).to have_content 'Agreed'
    click_link 'Mark as started'
    click_button 'Mark as started'
    expect(page).to have_content 'Development marked as started'
    development.reload
    expect(development.state).to eq('started')
  end
end
