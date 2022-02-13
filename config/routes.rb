Rails.application.routes.draw do
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
    get '/sign_out', to: 'devise/sessions#destroy', as: :signout

    authenticated :user do
        root 'dashboard#default', as: :authenticated_root

        get :dashboard, to: "dashboard#default"

        resources :users do
          collection do
            get :search
          end
        end

        resources :payment_methods do
          collection do
            get :options
            get :search
          end
        end

        resources :employees do
          collection do
            get :options
            get :search
          end
        end

        resources :products do
          collection do
            get :options
            get :search
          end
        end

        resources :branch_offices
        resources :clients do
          collection do
            get :search
          end
        end

        resources :brands
        resources :sales do
          collection do
            get :options
            get :index_options
          end
        end
        resources :roles
        resources :accounts
        resources :events
        resources :departments do
          collection do
            get :options
          end
        end

        namespace :catalog do
          resources :expediture_types
          resources :client_types
          resources :event_types
        end
    end

    unauthenticated do
        root 'users/sessions#new', as: :unauthenticated_root
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
