class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price
      t.string :payment_method
      t.string :payment_status
      t.string :status
      t.string :transaction_id
      t.datetime :completed_at

      t.timestamps
    end
  end
end
