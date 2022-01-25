Rails.application.routes.draw do
  namespace :user do
    resources :roles
  end
  resources :roles
  resources :accounts
            resources :destinations do
        collection do
            get :truck_types
        end
    end
      resources :pilots
    
    devise_for :users,
    :controllers => {
        :registrations => "users/registrations",
        :confirmations => "users/confirmations",
        :passwords => "users/passwords",
        :sessions => "users/sessions"
    },
    :path => "",
    :path_names => {
        :sign_in  => 'login',
        :sign_out => 'logout',
        :sign_up  => 'register',
        :password => 'password',
        :confirmation => 'confirmation'
    }

    devise_scope :user do
        get '/signout', to: 'devise/sessions#destroy', as: :signout

        authenticated :user do
            root 'dashboard#default', as: :authenticated_root
        end

        unauthenticated do
            root 'users/sessions#new', as: :unauthenticated_root
        end
    end

    #main
    get 'dashboard', to: 'dashboard#dashboard'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
