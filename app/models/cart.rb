class Cart < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    has_many :products, through: :cart_items
    
    def total_price
      cart_items.sum { |item| item.product.total_price * item.quantity }
    end
  end