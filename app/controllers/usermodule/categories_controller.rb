class Usermodule::CategoriesController < ApplicationController
    def index 
        @categories = Category.all
        @products = Product.all
      end
      
      def show
        @category = Category.find(params[:id])
        @subcategories = @category.subcategories
        @products = @category.products
      end
end
