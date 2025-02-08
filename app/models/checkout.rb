class Checkout < ApplicationRecord
  belongs_to :cart
  belongs_to :address  
  belongs_to :user
  
  has_many :order_items, through: :cart, source: :cart_items
  has_many :products, through: :order_items
  has_one :return_request

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validates :payment_status, presence: true

  STATUSES = %w[pending processing shipped delivered cancelled].freeze
  PAYMENT_STATUSES = %w[pending completed failed cancelled].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :payment_status, inclusion: { in: PAYMENT_STATUSES }

  def can_cancel?
    %w[pending processing].include?(status)
  end

  def can_update_address?
    %w[pending processing].include?(status)
  end

  def track_status_change(from_status, to_status, changed_by, notes = nil)
    order_status_histories.create!(
      from_status: from_status,
      to_status: to_status,
      changed_by: changed_by,
      notes: notes
    )
  end
end
