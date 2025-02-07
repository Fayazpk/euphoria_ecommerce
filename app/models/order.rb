class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum status: { processing: 0, packing: 1, transit: 2, delivered: 3, cancelled: 4 }

  validates :status, presence: true

  def update_status(new_status)
    self.status = new_status
    save
  end

  def can_update_address?
    processing? || packing?
  end

  def can_return_items?
    delivered?
  end
end
