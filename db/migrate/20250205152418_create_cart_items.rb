class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :product_variant, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true  # Changed from add_reference
      t.integer :quantity

      t.timestamps
    end
  end
end