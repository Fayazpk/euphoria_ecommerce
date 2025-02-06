Rails.application.routes.draw do
  resources :posts

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :usermodule do
    get "home"
    resources :categories do
      resources :subcategories do
        resources :products do
          resources :productviews, only: [:index]
        end
      end
    end
  
    resources :carts, only: [:index]
    resources :cart_items, only: [:create, :update, :destroy]
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
