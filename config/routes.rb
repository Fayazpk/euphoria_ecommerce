Rails.application.routes.draw do
  resources :registrations
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_reset
  resources :password
  resources :posts
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :usermodule do
    get "orders/index"
    get "orders/show"
    get "orders/update_address"
    get "orders/return_item"
    get "home"
    resources :categories do
      resources :subcategories do
        resources :products do
          resources :productviews, only: [:index]
        end
      end
    end
    resources :addresses
    resources :carts, only: [:index]
    resources :cart_items, only: [:create, :update, :destroy]
    resource :wallet, only: [:show] do
      member do
        post :add_money
        post :deduct_money
      end
    end
    resources :checkouts do
      collection do
        post :apply_coupon
      end
    end
    resources :orders do
      member do
        patch :update_address
        post :return_item
        get :track
      end
      resources :return_requests, only: [:create, :show]
    end
  end

  namespace :admin do
    resources :coupons
    resources :subcategories
    resources :categories
    resources :products
    resources :orders do
      member do
        patch :update_status
      end
      resources :return_requests do
        member do
          patch :process_return
        end
      end
    end
  end

  root 'usermodule/home#index'
  get "/favicon.ico", to: "application#favicon"
end
