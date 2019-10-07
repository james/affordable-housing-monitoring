require 'rails_helper'

RSpec.feature 'Signing in', type: :feature do
  scenario 'trying to view the home page without signing in' do
    visit root_path
    expect(current_path).to eq('/users/sign_in')
    expect(page).to have_text('You need to sign in before continuing')
  end

  scenario 'succesfully' do
    user = create(:user)
    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    expect(page).to have_text('Signed in successfully')
  end

  scenario 'with incorrect password' do
    create(:user)
    visit root_path
    fill_in 'Email', with: 'wrong@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    expect(page).to have_text('Invalid Email or password')
  end

  scenario 'signing out' do
    login
    click_on 'Log out'

    expect(page).to have_text('You need to sign in before continuing')
  end
end
