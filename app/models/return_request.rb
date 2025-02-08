class ReturnRequest < ApplicationRecord
  include AASM

  belongs_to :order_item
  belongs_to :user

  validates :reason, presence: true
  validates :status, presence: true

  STATUSES = %w[pending approved rejected completed].freeze
  validates :status, inclusion: { in: STATUSES }

  aasm column: :status do
    state :pending, initial: true
    state :approved
    state :rejected
    state :completed

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :complete do
      transitions from: :approved, to: :completed
      after do
        update(processed_at: Time.current)
      end
    end
  end
end