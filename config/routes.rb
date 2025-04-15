Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup',
    password: 'password',
    confirmation: 'confirmation'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  namespace :api do
    namespace :v1 do
      resources :categories, only: [:index, :show]
      resources :products, only: [:index, :show]

      resource :cart, only: [:show] do
        resources :cart_items, only: [:create, :update, :destroy]
      end

      resources :orders, only: [:index, :show, :create]
    end
  end

  namespace :admin do
    resources :categories, except: [:new, :edit]
    resources :products, except: [:new, :edit]

    resources :products do
      resources :variants, except: [:new, :edit]
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
