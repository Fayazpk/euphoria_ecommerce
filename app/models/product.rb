class Product < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory
  has_many_attached :images
  has_many :product_variants, dependent: :destroy

  accepts_nested_attributes_for :product_variants, allow_destroy: true

  validates :name, presence: true
  validates :description, presence: true
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true
  validates :subcategory, presence: true
  validates :images, presence: true

  before_save :calculate_total_price

  def discount_amount
    return 0 if discount_percentage.nil? || discount_percentage.zero?
    base_price * (discount_percentage / 100.0)
  end

  def calculate_total_price
    self.total_price = discount_percentage.present? && discount_percentage > 0 ? base_price * (1 - (discount_percentage / 100.0)) : base_price
  end
end
