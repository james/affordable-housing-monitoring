Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :developments, only: %i[index new create]
end
