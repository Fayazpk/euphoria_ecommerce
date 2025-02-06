class AddUserToCart < ActiveRecord::Migration[8.0]
  def change
    add_reference :carts, :user, foreign_key: true, null: true
  end
end
