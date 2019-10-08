Rails.application.routes.draw do
  devise_for :users
  root 'developments#index'

  resources :developments, only: %i[index new create edit update]

  get '/check', to: proc { [200, {}, ['OK']] }
end
