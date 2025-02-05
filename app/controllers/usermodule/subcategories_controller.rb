class Usermodule::SubcategoriesController < ApplicationController
    def index
        @category = Category.find(params[:category_id])
        @subcategories = @category.subcategories
        @products = Product.all
    end
    
    def show
        @subcategory = Subcategory.find(params[:id])
        @products = @subcategory.products
    end
end
