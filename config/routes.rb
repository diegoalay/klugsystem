Rails.application.routes.draw do
  namespace :employee do
    resources :files
  end
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

        get :profile, to: "profile#show"
        put :profile, to: "profile#update"

        get :dashboard, to: "dashboard#default"

        resources :users do
          collection do
            get :search
          end
        end

        resources :cash_registers do
        end

        resources :expeditures do
          collection do
            get :options
            get :index_options
          end
        end

        resources :payment_methods do
          collection do
            get :options
            get :search
          end
        end

        resources :employees do
          scope module: :employee do
            resources :files
          end
          collection do
            get "files/extensions", to: "employee/files#extensions"
            get :options
            get :search
          end
        end

        resources :products do
          scope module: :product do
            resources :files
          end
          collection do
            get "files/extensions", to: "product/files#extensions"
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

        get '*path' => redirect('/')
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
