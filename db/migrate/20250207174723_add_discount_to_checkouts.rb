class AddDiscountToCheckouts < ActiveRecord::Migration[6.0]
  def change
    add_column :checkouts, :discount, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
