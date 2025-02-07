class WalletTransaction < ApplicationRecord
  belongs_to :wallet
  belongs_to :checkout, optional: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[credit debit] }
  validates :description, presence: true
  validates :transaction_id, presence: true, uniqueness: true

  

  scope :credits, -> { where(transaction_type: 'credit') }
  scope :debits, -> { where(transaction_type: 'debit') }
end
