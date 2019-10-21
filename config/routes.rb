Rails.application.routes.draw do
  devise_for :users
  root 'developments#index'

  resources :developments do
    resources :dwellings
    member do
      get :agree_confirmation
      patch :agree
      get :start_confirmation
      patch :start
      get :complete_confirmation
      patch :complete
    end
  end

  get '/check', to: proc { [200, {}, ['OK']] }
end
