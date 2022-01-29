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
    get '/signout', to: 'devise/sessions#destroy', as: :signout

    authenticated :user do
        root 'dashboard#default', as: :authenticated_root

        resources :products
        resources :branch_offices
        resources :clients do
          collection do
            get :search
          end
        end

        resources :brands
        resources :sales
        resources :roles
        resources :accounts
        resources :events
        resources :departments do
          collection do
            get :options
          end
        end

        namespace :catalog do
          resources :event_types
          resources :client_types
        end
    end

    unauthenticated do
        root 'users/sessions#new', as: :unauthenticated_root
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
