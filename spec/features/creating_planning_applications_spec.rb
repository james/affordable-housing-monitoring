require 'rails_helper'

RSpec.feature 'Creating planning applications', type: :feature do
  scenario 'successfully adding a planning application to a new development' do
    login
    development = create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage planning applications'
    click_link 'Add a new planning application'
    fill_in 'Application number', with: 'A111'
    click_button 'Add planning application'
    expect(page).to have_content('Planning application successfully added')
    development.reload
    planning_application = development.planning_applications.last
    expect(planning_application.application_number).to eq('A111')
  end

  scenario 'validation presence error adding a planning application' do
    login
    create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage planning applications'
    click_link 'Add a new planning application'
    fill_in 'Application number', with: ''
    click_button 'Add planning application'
    expect(page).to have_content("Application number can't be blank")
  end
end
