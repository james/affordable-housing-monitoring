require 'rails_helper'

RSpec.feature 'Requesting a developer completion response', type: :feature do
  scenario 'when development is unconfirmed_completed and has incomplete dwelling' do
    development = create(:development, state: 'unconfirmed_completed')
    login
    click_link 'AP/2019/1234'
    expect(page).to have_content 'Developer completion response needed'
    expect(find_field('developer_response_url').value).to have_content(completion_response_form_development_path(development))
  end

  scenario 'when development is confirmed_completed' do
    create(:development, state: 'confirmed_completed')
    login
    click_link 'AP/2019/1234'
    expect(page).to have_content 'The developer has responded with the full details for this development.'
  end

  scenario 'when development is not unconfirmed_completed' do
    create(:development)
    login
    click_link 'AP/2019/1234'
    expect(page).to_not have_content 'Developer completion response needed'
  end
end
