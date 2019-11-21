require 'rails_helper'

RSpec.feature 'Editing planning applications', type: :feature do
  scenario 'successfully editing a planning application on a new development' do
    login
    development = create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage planning applications'
    click_link 'Edit'
    fill_in 'Application number', with: 'A1001'
    click_button 'Save planning application'
    expect(page).to have_content('Planning application successfully saved')
    development.reload
    planning_application = development.planning_applications.last
    expect(planning_application.application_number).to eq('A1001')
  end

  scenario 'validation presence error editing a dwelling' do
    login
    create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage planning applications'
    click_link 'Edit'
    fill_in 'Application number', with: ''
    click_button 'Save planning application'
    expect(page).to have_content("Application number can't be blank")
  end
end
