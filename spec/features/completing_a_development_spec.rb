require 'rails_helper'

RSpec.feature 'Marking a development as completed', type: :feature do
  scenario 'successfully' do
    development = create(:development, state: 'started')
    login
    click_link 'AP/2019/1234'
    expect(page).to have_content 'Started'
    click_link 'Mark as completed'
    click_button 'Mark as completed'
    expect(page).to have_content 'Development marked as completed'
    development.reload
    expect(development.state).to eq('unconfirmed_completed')
  end
end
