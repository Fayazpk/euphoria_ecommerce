class CreateWalletTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :wallet_transactions do |t|
      t.references :wallet, null: false, foreign_key: true
      t.decimal :amount
      t.string :transaction_type
      t.text :description
      t.decimal :balance_after
      t.string :transaction_id

      t.timestamps
    end
  end
end
