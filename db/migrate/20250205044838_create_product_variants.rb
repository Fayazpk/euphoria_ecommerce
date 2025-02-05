class CreateProductVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.references :size, null: false, foreign_key: true
      t.integer :stock

      t.timestamps
    end
  end
end
