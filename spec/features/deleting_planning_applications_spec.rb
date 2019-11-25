require 'rails_helper'

RSpec.feature 'Deleting planning applications', type: :feature do
  scenario 'successfully' do
    login
    development = create(:development)
    planning_application = create(:planning_application, development: development, application_number: 'AP/2019/4444')
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage planning applications'
    within(:xpath, "//th[text() = '#{planning_application.application_number}']/parent::tr") do
      click_link 'Edit'
    end
    click_button 'Delete planning application'
    expect(page).to have_content('Planning application deleted')
    development.reload
    expect(development.planning_applications.count).to eq(1)
  end

  scenario 'when only one planning application exists on development' do
    login
    create(:development)
    visit developments_path
    click_link 'AP/2019/1234'
    click_link 'Manage planning applications'
    click_link 'Edit'
    expect(page).to_not have_content('Delete planning application')
    expect(page).to have_content('You cannot delete the only planning application')
  end
end
