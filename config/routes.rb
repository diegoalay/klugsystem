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
    mount ActionCable.server => '/cable'

    get '/sign_out', to: 'users/sessions#destroy', as: :signout

    authenticated :user do
      root 'dashboard#default', as: :authenticated_root

      get :profile, to: "profile#show"
      put :profile, to: "profile#update"

      get :dashboard, to: "dashboard#default"

      namespace :crm do
        resources :events
        resources :contacts do
          collection do
            get :search
          end
        end
        resources :clients do
          collection do
            get :search
          end
        end
      end

      namespace :pos do
        resources :sales do
          collection do
            get :options
            get :index_options
          end
          member do
            post :send_sale
            get :emails_sent
          end
        end

        resources :expeditures do
          collection do
            get :options
            get :index_options
          end
        end
        resource :cash_register
        post 'cash_register/create', to: "cash_registers#create"
      end

      namespace :finance do
        resources :cash_registers do
        end
        resources :sales do
          collection do
            get :options
            get :index_options
          end
          member do
            post :send_sale
            get :emails_sent
          end
        end

        resources :quotations do
          collection do
            get :options
            get :index_options
          end
        end

        resources :expeditures do
          collection do
            get :options
            get :index_options
          end
        end
      end

      namespace :inventory do
        resources :brands
        resources :measurement_units
        resources :departments do
          collection do
            get :options
          end
        end

        resources :products do
          scope module: :product do
            resources :files
            resources :transactions
          end
          collection do
            get "transactions/options", to: "product/transactions#options"
            get "files/extensions", to: "product/files#extensions"
            get :options
            get :search
          end
        end
      end

      namespace :hr do
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
      end

      namespace :purchases  do
        resources :providers do
          scope module: :provider do
            resources :contacts
          end
        end
      end

      namespace :reports do
        resource :sales do
          collection do
            get :options
            get :index_options
          end
        end
        resource :sale_details do
          get :options
        end
      end

      resources :books do
      end

      namespace :configurations do
        resources :product_transaction_types
        resources :expediture_types
        resources :client_types
        resources :event_types
      end
    end

    namespace :administration do
      resources :menu_items, only: %i[index]
      resource :account
      resource :digifact do
        collection do
          post :validate
        end
      end
      resources :users do
        collection do
          get :options
          get :search
        end
      end
      resources :branch_offices
      resources :roles do
        scope module: :role do
          resources :menu_items
        end
        member do
          get :users
        end
      end
      resources :payment_methods do
        collection do
          get :options
          get :search
        end
      end
    end

    unauthenticated do
      get :reset_password, to: 'users/passwords#new'

      get '*path' => redirect('/login')

      get '/login', to: 'users/passwords#new'

      root to: "users/passwords#new"
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
