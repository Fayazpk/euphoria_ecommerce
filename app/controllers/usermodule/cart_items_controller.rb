module Usermodule
  class CartItemsController < ApplicationController
    before_action :initialize_cart

    def create
      @cart_item = current_cart.cart_items.build(cart_item_params)
      set_default_values(@cart_item)

      if @cart_item.save
        flash[:notice] = 'Item added to cart successfully.'
        redirect_to usermodule_carts_path  # Updated redirect path
      else
        flash[:alert] = 'Failed to add item to cart.'
        redirect_back(fallback_location: root_path)
      end
    end

    def update
      @cart_item = current_cart.cart_items.find(params[:id])
      set_default_values(@cart_item)
      
      if @cart_item.update(cart_item_params)
        flash[:notice] = 'Cart updated successfully.'
      else
        flash[:alert] = 'Failed to update cart.'
      end
      redirect_to usermodule_carts_path
    end

    def destroy
      @cart_item = current_cart.cart_items.find(params[:id])
      @cart_item.destroy
      flash[:notice] = 'Item removed from cart.'
      redirect_to usermodule_carts_path
    end

    private

    def cart_item_params
      params.require(:cart_item).permit(:product_id, :product_variant_id, :quantity)
    end

    def set_default_values(cart_item)
      cart_item.quantity ||= 1
      cart_item.product_variant_id ||= ProductVariant.find_by(size: 'S').id
    end

    def initialize_cart
      session[:cart_id] ||= Cart.create.id
    end

    def current_cart
      Cart.find_by(id: session[:cart_id]) || Cart.create
    end
  end
end
