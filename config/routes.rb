Rails.application.routes.draw do
  devise_for :users
  root 'developments#index'

  resources :developments

  get '/check', to: proc { [200, {}, ['OK']] }
end
