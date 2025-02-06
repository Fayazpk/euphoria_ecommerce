class Usermodule::ProductviewsController < ApplicationController
    before_action :set_product, only: [:index]
  
    def index
      Rails.logger.debug "Product ID: #{params[:product_id]}"
      Rails.logger.debug "Product: #{@product.inspect}"
      
      @related_products = Product.where(subcategory: @product.subcategory)
                                 .where.not(id: @product.id)
                                 .limit(4)
      
      @variants = @product.product_variants
      Rails.logger.debug "Variants: #{@variants.inspect}"
    end
  
    private
  
    def set_product
      @product = Product.find_by(id: params[:product_id])
      
      if @product.nil?
        Rails.logger.error "Product not found for ID: #{params[:product_id]}"
        flash[:alert] = "Product not found"
        redirect_to root_path and return
      end
    end
  end