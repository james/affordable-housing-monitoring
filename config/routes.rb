Rails.application.routes.draw do
  devise_for :users
  root 'developments#index'

  resources :developments do
    resources :dwellings, only: %i[index create edit update]
  end

  get '/check', to: proc { [200, {}, ['OK']] }
end
