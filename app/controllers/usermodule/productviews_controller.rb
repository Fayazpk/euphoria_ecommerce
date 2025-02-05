class Usermodule::ProductviewsController < ApplicationController
    before_action :set_product, only: [:index]
  
    def index
      @related_products = Product.where(subcategory: @product.subcategory)
                                 .where.not(id: @product.id)
                                 .limit(4)
      @variants = @product.product_variants
    end
  
    private
  
    def set_product
      @product = Product.find_by(id: params[:product_id])
      unless @product
        flash[:alert] = "Product not found"
        redirect_to root_path
      end
    end
  end
  