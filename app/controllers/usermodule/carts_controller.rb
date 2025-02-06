module Usermodule
  class CartsController < ApplicationController
    before_action :set_cart

    def index
      @cart_items = @cart.cart_items.includes(:product, :product_variant)
    end

    private

    def set_cart
      @cart = current_cart
    end

    def current_cart
      Cart.find_by(id: session[:cart_id]) || Cart.create
    end
  end
end
