module Usermodule
  class CheckoutsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_checkout, only: %i[show edit update destroy]
    before_action :load_addresses, only: [:new, :create]
    before_action :load_coupons, only: [:new, :create]
    before_action :initialize_checkout, only: [:new, :create]

    def index
      Rails.logger.info("Fetching all checkouts for user: #{current_user.id}")
      @checkouts = current_user.checkouts.order(created_at: :desc)
    end

    def initialize_checkout
      Rails.logger.info("Initializing checkout for user: #{current_user.id}")
      @checkout = current_user.checkouts.new
      @cart = current_user.cart || create_cart_for_user(current_user)
      
      if @cart.cart_items.empty?
        Rails.logger.warn("Cart is empty for user: #{current_user.id}")
        redirect_to usermodule_carts_path, alert: 'Your cart is empty' and return
      end

      @subtotal = calculate_subtotal
      Rails.logger.info("Calculated subtotal: #{@subtotal}")
      @tax = calculate_tax(@subtotal)
      Rails.logger.info("Calculated tax: #{@tax}")
      @shipping = calculate_shipping
      Rails.logger.info("Calculated shipping: #{@shipping}")
      @total = @subtotal + @tax + @shipping
      Rails.logger.info("Calculated total: #{@total}")
      @discount = 0
    end

    def new
      Rails.logger.info("Rendering new checkout form for user: #{current_user.id}")
      render :new
    end

    def create
      if @cart.cart_items.empty?
        Rails.logger.warn("Attempt to create checkout with an empty cart for user: #{current_user.id}")
        return redirect_to usermodule_cart_path, alert: 'Your cart is empty'
      end

      ActiveRecord::Base.transaction do
        begin
          coupon_code = params[:checkout][:coupon_code]
          Rails.logger.info("Applying coupon code: #{coupon_code} for user: #{current_user.id}")
          @coupon = Coupon.find_by(code: coupon_code)
          
          @discount = @coupon && @coupon.can_apply?(@subtotal) ? @coupon.discount : 0
          Rails.logger.info("Calculated discount: #{@discount}")
          @total = @subtotal + @tax + @shipping - @discount
          Rails.logger.info("Calculated total after discount: #{@total}")

          @checkout.assign_attributes(
  cart: @cart,
  address_id: checkout_params[:address_id],
  payment_method: checkout_params[:payment_method],
  total_price: @total,
  discount: @discount,
  tax: @tax,
  status: 'pending'
)

          Rails.logger.info("Assigned checkout attributes: #{@checkout.attributes}")

          if @checkout.payment_method == 'wallet'
            unless current_user.wallet.deduct_money(@checkout.total_price, @checkout, "Purchase payment")
              raise StandardError, "Insufficient wallet balance"
            end
            @checkout.payment_status = 'completed'
            Rails.logger.info("Wallet payment completed for user: #{current_user.id}")
          else
            @checkout.payment_status = 'pending'
            Rails.logger.info("Non-wallet payment selected for user: #{current_user.id}")
          end

          if @checkout.save
            Rails.logger.info("Checkout successfully created for user: #{current_user.id}")
            decrease_product_variant_stock(@cart)
            Rails.logger.info("Decreased product variant stock for user: #{current_user.id}")
            clear_cart(@cart)
            Rails.logger.info("Cleared cart for user: #{current_user.id}")

            redirect_to usermodule_checkouts_path, notice: 'Order was successfully created.' and return
          else
            raise StandardError, @checkout.errors.full_messages.join(", ")
          end
        rescue StandardError => e
          Rails.logger.error("Checkout failed for user: #{current_user.id} - #{e.message}")
          flash.now[:alert] = "Checkout failed: #{e.message}"
          render :new and return
        end
      end
    end

    def show
      Rails.logger.info("Showing checkout with ID: #{params[:id]} for user: #{current_user.id}")
    end

    def edit
      Rails.logger.info("Editing checkout with ID: #{params[:id]} for user: #{current_user.id}")
    end

    def update
      Rails.logger.info("Updating checkout with ID: #{params[:id]} for user: #{current_user.id}")
      respond_to do |format|
        if @checkout.update(checkout_params)
          Rails.logger.info("Checkout with ID: #{params[:id]} successfully updated for user: #{current_user.id}")
          format.html { redirect_to @checkout, notice: 'Checkout was successfully updated.' }
        else
          Rails.logger.error("Failed to update checkout with ID: #{params[:id]} for user: #{current_user.id} - #{@checkout.errors.full_messages.join(", ")}")
          format.html { render :edit }
        end
      end
    end

    def destroy
      Rails.logger.info("Destroying checkout with ID: #{params[:id]} for user: #{current_user.id}")
      @checkout.destroy
      respond_to do |format|
        format.html { redirect_to usermodule_checkouts_url, notice: 'Checkout was successfully destroyed.' }
      end
    end

    def apply_coupon
      @cart = current_user.cart || create_cart_for_user(current_user)
      coupon_code = params[:coupon_code]
      Rails.logger.info("Applying coupon: #{coupon_code} for user: #{current_user.id}")
      
      @coupon = Coupon.find_by(code: coupon_code)
      subtotal = calculate_subtotal
      Rails.logger.info("Current subtotal: #{subtotal} for user: #{current_user.id}")
      
      if @coupon && @coupon.can_apply?(subtotal)
        @discount = @coupon.discount
        @total = subtotal + calculate_tax(subtotal) + calculate_shipping - @discount
        Rails.logger.info("Coupon applied successfully: Discount - #{@discount}, Total - #{@total} for user: #{current_user.id}")

        render json: { success: true, discount: @discount, total: @total }
      else
        Rails.logger.warn("Invalid or inactive coupon code: #{coupon_code} for user: #{current_user.id}")
        render json: { success: false, error: 'Invalid or inactive coupon', total: subtotal + calculate_tax(subtotal) + calculate_shipping }
      end
    end

    private
    
    def load_coupons
      Rails.logger.info("Loading available coupons for user: #{current_user.id}")
      @coupons = Coupon.where(status: true)
                       .where('valid_from <= ? AND valid_until >= ?', Date.today, Date.today)
                       .to_a || []
    end

    def load_addresses
      Rails.logger.info("Loading addresses for user: #{current_user.id}")
      @addresses = current_user.addresses
      if @addresses.empty?
        Rails.logger.warn("No shipping address found for user: #{current_user.id}")
        flash[:alert] = "Please add a shipping address before proceeding to checkout"
        redirect_to new_usermodule_address_path and return
      end
    end

    def set_checkout
      Rails.logger.info("Attempting to find checkout with ID: #{params[:id]} for user: #{current_user.id}")
      @checkout = current_user.checkouts.find_by(id: params[:id])
      if @checkout.nil?
        Rails.logger.error("Checkout not found for user: #{current_user.id}")
        flash[:alert] = "Checkout not found."
        redirect_to usermodule_checkouts_path and return
      end
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
        :razorpay_order_id,
        :razorpay_payment_id,
        :razorpay_signature,
        :coupon_code,
        :tax,
        :discount
      )
    end
    
    

    def calculate_subtotal
      Rails.logger.info("Calculating subtotal for user: #{current_user.id}")
      cart = current_user.cart || create_cart_for_user(current_user)
      cart.cart_items.sum { |cart_item|
        cart_item.product.base_price *
        (1 - cart_item.product.discount_percentage / 100.0) *
        cart_item.quantity 
      }
    end

    def calculate_tax(subtotal)
      Rails.logger.info("Calculating tax for subtotal: #{subtotal}")
      subtotal * 0.10
    end

    def calculate_shipping
      Rails.logger.info("Calculating shipping cost")
      10.0
    end

    def create_cart_for_user(user)
      Rails.logger.info("Creating cart for user: #{user.id}")
      cart = Cart.create(user: user)
      user.update(cart: cart)
      cart
    end

    def clear_cart(cart)
      Rails.logger.info("Clearing cart for user: #{cart.user.id}")
      cart.cart_items.destroy_all  
      cart.reload
    end

    def decrease_product_variant_stock(cart)
      Rails.logger.info("Decreasing product variant stock for user: #{cart.user.id}")
      cart.cart_items.each do |cart_item|
        product_variant = cart_item.product_variant
        product_variant.with_lock do  
          new_stock = product_variant.stock - cart_item.quantity
          if new_stock < 0
            Rails.logger.error("Insufficient stock for #{product_variant.product.name} for user: #{cart.user.id}")
            raise StandardError, "Insufficient stock for #{product_variant.product.name}"
          end
          product_variant.update!(stock: new_stock)
        end
      end
    end
  end
end
