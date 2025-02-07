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
    resources :checkouts, only: [:new, :create, :show] do
      collection do
        post :apply_coupon
      end
    end
    resources :orders, only: [:index, :show] do
      member do
        patch :update_address
        post :return_item
      end
    end
  end

  namespace :admin do
    resources :coupons
    resources :subcategories
    resources :categories
    resources :products
  end

  root 'usermodule/home#index'
  get "/favicon.ico", to: "application#favicon"
end
