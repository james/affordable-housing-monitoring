Rails.application.routes.draw do
  devise_for :users
  root 'developments#index'

  resources :developments do
    resources :dwellings
  end

  get '/check', to: proc { [200, {}, ['OK']] }
end
