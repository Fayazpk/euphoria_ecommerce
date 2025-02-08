class Order < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :address
  has_many :order_items, dependent: :destroy
  has_many :order_status_histories, dependent: :destroy
  has_many :products, through: :order_items
  has_many :return_requests, through: :order_items

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validates :payment_status, presence: true

  STATUSES = %w[processing packing transit delivered cancelled].freeze
  PAYMENT_STATUSES = %w[pending completed failed refunded].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :payment_status, inclusion: { in: PAYMENT_STATUSES }

  aasm column: :status do
    state :processing, initial: true
    state :packing
    state :transit
    state :delivered
    state :cancelled

    event :pack do
      transitions from: :processing, to: :packing
    end

    event :ship do
      transitions from: :packing, to: :transit
    end

    event :deliver do
      transitions from: :transit, to: :delivered
      after do
        update(delivered_at: Time.current)
      end
    end

    event :cancel do
      transitions from: [:processing, :packing], to: :cancelled
    end
  end

  def can_update_address?
    %w[processing packing].include?(status)
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