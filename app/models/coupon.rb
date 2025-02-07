class Coupon < ApplicationRecord
    # Validations
    validates :code, presence: true, uniqueness: true
    validates :discount, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :description, presence: true
    validates :valid_from, presence: true
    validates :valid_until, presence: true
    validates :max_usage, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :status, inclusion: { in: [true, false] }
    validates :minimum_purchase_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
    # Custom method to check if the coupon is active and valid
    def active?
      status && Date.today.between?(valid_from, valid_until)
    end
  
    # Custom method to check if the coupon can be applied
    def can_apply?(total_amount)
      active? && total_amount >= minimum_purchase_amount
    end
  end
  