class AddCouponCodeToCheckouts < ActiveRecord::Migration[8.0]
  def change
    add_column :checkouts, :coupon_code, :string
  end
end
