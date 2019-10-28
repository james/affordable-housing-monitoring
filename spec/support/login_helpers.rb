def login(user = nil)
  user ||= create(:user)
  visit root_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
  user
end
