class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :product_variant

  def return_item
    # Implement return logic here
  end
end
