class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  belongs_to :product_variant
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_variant_id, presence: true
  validates :product_id, presence: true
  
  def total_price
    product.total_price * quantity
  end
end