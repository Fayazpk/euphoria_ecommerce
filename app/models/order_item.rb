class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :product_variant
  has_one :return_request, dependent: :destroy

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :calculate_total

  def returnable?
    return false unless order.delivered?
    return false if return_request.present?
    
    delivered_at = order.delivered_at
    return false unless delivered_at
    
    (Time.current - delivered_at) <= 7.days
  end

  private

  def calculate_total
    self.total = quantity * unit_price if quantity.present? && unit_price.present?
  end
end