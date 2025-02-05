class Usermodule::HomeController < ApplicationController
    def index
      @featured_products = Product.all.limit(4)
    end
  
    def about
    end
  
    def contact
    end
  
    def newsletter_subscribe
      # Handle newsletter subscription logic here
    end
  end
  