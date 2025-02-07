module Usermodule
  class CheckoutsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_checkout, only: %i[show edit update destroy]

    def new
      @checkout = current_user.checkouts.build  # Use .build instead of .new
      @cart = current_user.cart || create_cart_for_user(current_user)
      @addresses = current_user.addresses.to_a
      @coupons = Coupon.where(status: true)
                 .where('valid_from <= ? AND valid_until >= ?', Date.today, Date.today)
                 .to_a
      @subtotal = calculate_subtotal
      @tax = calculate_tax(@subtotal)
      @shipping = calculate_shipping
      @total = @subtotal + @tax + @shipping
      @discount = 0
    end

    def create
      @cart = current_user.cart || create_cart_for_user(current_user)
      
      @subtotal = calculate_subtotal
      @tax = calculate_tax(@subtotal)
      @shipping = calculate_shipping

      coupon_code = params[:checkout][:coupon_code]
      @coupon = Coupon.find_by(code: coupon_code)
      
      @discount = @coupon && @coupon.can_apply?(@subtotal) ? @coupon.discount : 0
      @total = @subtotal + @tax + @shipping - @discount
    
      @checkout = current_user.checkouts.build(
        cart: @cart,
        address_id: checkout_params[:address_id],
        payment_method: checkout_params[:payment_method],
        total_price: @total,
        discount: @discount  # Ensure discount is stored with the checkout
      )

      if @checkout.payment_method == 'wallet'
        if current_user.wallet.deduct_money(@checkout.total_price, @checkout, "Purchase payment")
          @checkout.payment_status = 'completed'
        else
          flash[:alert] = "Wallet payment failed or is pending: #{current_user.wallet.errors.full_messages.join(", ")}"
          render :new and return
        end
      elsif @checkout.payment_method == 'cod'
        @checkout.payment_status = 'pending'
      end
    
      respond_to do |format|
        if @checkout.save
          decrease_product_variant_stock(@cart)  # Decrease the product variant stock after successful checkout
          clear_cart(@cart)  # Clear the cart after successful checkout
          format.html { redirect_to usermodule_checkout_path(@checkout), notice: 'Checkout was successfully created.' }
        else
          format.html { 
            render :new, alert: 'Failed to create checkout. Please check the errors.' 
          }
        end
      end
    end

    def show
      @checkout = current_user.checkouts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The requested checkout could not be found."
      redirect_to usermodule_checkouts_path
    end

    def edit
    end

    def update
      respond_to do |format|
        if @checkout.update(checkout_params)
          format.html { redirect_to @checkout, notice: 'Checkout was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      @checkout.destroy
      respond_to do |format|
        format.html { redirect_to usermodule_checkouts_url, notice: 'Checkout was successfully destroyed.' }
      end
    end

    def apply_coupon
      @cart = current_user.cart || create_cart_for_user(current_user)
      coupon_code = params[:coupon_code]
      @coupon = Coupon.find_by(code: coupon_code)
    
      Rails.logger.info("Coupon: #{@coupon.inspect}, Subtotal: #{calculate_subtotal}, Can Apply: #{@coupon.can_apply?(calculate_subtotal)}")
      if @coupon && @coupon.can_apply?(calculate_subtotal)
        @discount = @coupon.discount
        @total = calculate_subtotal + calculate_tax(calculate_subtotal) + calculate_shipping - @discount
    
        render json: { success: true, discount: @discount, total: @total }
      else
        render json: { success: false, error: 'Invalid or inactive coupon', total: calculate_subtotal + calculate_tax(calculate_subtotal) + calculate_shipping }
      end
    end

    private

    def set_checkout
      @checkout = current_user.checkouts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The requested checkout could not be found."
      redirect_to usermodule_checkouts_path
    end

    def checkout_params
      params.require(:checkout).permit(
        :cart_id, 
        :address_id, 
        :user_id, 
        :payment_method, 
        :total_price, 
        :status, 
        :payment_status,
        :coupon_code 
      )
    end

    def calculate_subtotal
      cart = current_user.cart || create_cart_for_user(current_user)
      cart.cart_items.sum { |cart_item|
        cart_item.product.base_price *
        (1 - cart_item.product.discount_percentage / 100.0) *
        cart_item.quantity 
      }
    end

    def calculate_tax(subtotal)
      subtotal * 0.10
    end

    def calculate_shipping
      10.0
    end

    def create_cart_for_user(user)
      cart = Cart.create(user: user)
      user.update(cart: cart)
      cart
    end

    def clear_cart(cart)
      cart.cart_items.destroy_all
    end

    def decrease_product_variant_stock(cart)
      cart.cart_items.each do |cart_item|
        product_variant = cart_item.product_variant
        product_variant.update!(stock: product_variant.stock - cart_item.quantity)
      end
    end
  end
end
