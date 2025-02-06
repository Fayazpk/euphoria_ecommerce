class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :balance, precision: 15, scale: 2, default: 0.0

      t.timestamps
    end

    unless index_exists?(:wallets, :user_id)
      add_index :wallets, :user_id, unique: true
    end
  end
end
