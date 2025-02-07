class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :product_variant, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :total
      t.string :size

      t.timestamps
    end
  end
end
