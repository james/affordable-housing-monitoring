Rails.application.routes.draw do
  devise_for :users
  root 'developments#index'

  resources :developments do
    resources :dwellings do
      member do
        get :delete
      end
    end
    resources :planning_applications
    member do
      get :add_to_scheme

      get :agree_confirmation
      patch :agree
      get :start_confirmation
      patch :start
      get :complete_confirmation
      patch :complete

      get :completion_response_form
      patch :completion_response

      get :rp_response_form
      patch :rp_response
    end
  end

  resources :schemes

  get '/check', to: proc { [200, {}, ['OK']] }
end
