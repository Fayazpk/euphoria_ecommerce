class AddCheckoutIdToWalletTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :wallet_transactions, :checkout_id, :integer
  end
end
