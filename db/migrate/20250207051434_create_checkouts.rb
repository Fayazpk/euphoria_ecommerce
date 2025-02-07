class CreateCheckouts < ActiveRecord::Migration[8.0]
  def change
    create_table :checkouts do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :payment_method
      t.decimal :total_price
      t.string :status
      t.string :payment_status
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.string :razorpay_signature

      t.timestamps
    end
  end
end
