require 'rails_helper'

RSpec.feature 'Requesting responses from RPs and developers', type: :feature do
  scenario 'when development is unconfirmed_completed' do
    development = create(:development, state: 'unconfirmed_completed')
    login
    click_link 'AP/2019/1234'
    expect(page).to have_content 'Developer completion response needed'
    expect(find_field('developer_response_url').value).to have_content(completion_response_form_development_path(development))
  end

  scenario 'when development is partially_confirmed_completed' do
    development = create(:development, state: 'partially_confirmed_completed')
    login
    click_link 'AP/2019/1234'
    expect(page).to have_content 'Registered Provider response needed'
    expect(find_field('rp_response_url').value).to have_content(rp_response_form_development_path(development))
  end

  scenario 'when development is confirmed_completed' do
    create(:development, state: 'confirmed_completed')
    login
    click_link 'AP/2019/1234'
    expect(page).to have_content 'The developer and registered provider have responded with the full details for this development.'
  end

  scenario 'when development is not unconfirmed_completed' do
    create(:development)
    login
    click_link 'AP/2019/1234'
    expect(page).to_not have_content 'Developer completion response needed'
  end
end
