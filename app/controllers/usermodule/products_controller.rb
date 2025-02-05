module Usermodule
    class ProductsController < ApplicationController
      def index
        @products = Product.all
  
        if params[:search].present?
          @products = @products.where("name ILIKE ? OR description ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
        end
  
        case params[:sort]
        when 'price_asc'
          @products = @products.order(total_price: :asc)
        when 'price_desc'
          @products = @products.order(total_price: :desc)
        when 'newest'
          @products = @products.order(created_at: :desc)
        when 'discount'
          @products = @products.order(discount_percentage: :desc)
        end
      end
  
      def show
        @product = Product.find(params[:id])
      end
    end
  end
  