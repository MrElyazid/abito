Rails.application.routes.draw do
  resource :cart, only: [:show] do
    resources :cart_items, only: [:update, :destroy] # Routes for updating/removing items in cart
  end
  resources :categories, only: [:show]
  resources :products, only: [:index, :show, :new, :create] do
    resources :cart_items, only: [:create]
    resources :comments, only: [:create] # Nested route for creating comments
  end
  resources :orders, only: [:create, :index, :show] # Routes for checkout and user order history
  devise_for :users

  # Admin Section
  namespace :admin do
    root to: 'dashboard#index' # /admin
    resources :products do 
      collection do 
        get :pending_submissions
      end
      member do
        patch :accept_submission
        patch :reject_submission
      end
    end# Full CRUD for products under /admin/products
    resources :categories # Add routes for admin category management
    resources :users, only: [:index, :show, :destroy] # Add routes for admin user management
    resources :orders, only: [:index, :show] # Add routes for admin order viewing
  end

  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
