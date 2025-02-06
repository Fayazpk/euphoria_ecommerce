module Usermodule
  class CartsController < ApplicationController
    before_action :set_cart

    def index                                                                                                            
      if current_user
        @cart_items = @cart.cart_items.includes(:product, :product_variant)
      else
        redirect_to new_user_session_path, alert: 'You need to sign in or sign up before continuing.'
      end
      @products = Product.all
    end

    private

    def set_cart
      @cart = current_user.cart || current_user.create_cart!
    end

    def current_cart
      Cart.find_by(id: session[:cart_id]) || Cart.create
    end
  end
end
