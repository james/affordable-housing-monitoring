require 'rails_helper'

RSpec.feature 'Associating a Development to a Scheme', type: :feature do
  scenario 'successfully' do
    scheme = create(:scheme)
    development = create(:development)
    login
    click_link 'AP/2019/1234'
    click_link 'Add to a scheme'
    select 'AP/2019/6789', from: 'Scheme'
    click_button 'Add to scheme'
    development.reload
    expect(development.scheme).to eq(scheme)
  end

  scenario 'editing if development already belongs to a scheme' do
    scheme = create(:scheme)
    development = create(:development, scheme: scheme)
    login
    click_link 'AP/2019/1234'
    find('a', text: 'Edit scheme', visible: false).click
    select 'None', from: 'Scheme'
    click_button 'Add to scheme'
    development.reload
    expect(development.scheme).to eq(nil)
  end
end
