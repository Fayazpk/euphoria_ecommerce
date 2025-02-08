class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price, precision: 10, scale: 2
      t.string :payment_method
      t.string :payment_status
      t.string :status, default: 'processing'
      t.string :transaction_id
      t.datetime :completed_at
      t.datetime :delivered_at
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end

    add_index :orders, :status
    add_index :orders, :payment_status
  end
end
