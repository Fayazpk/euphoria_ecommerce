class CreateOrderStatusHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :order_status_histories do |t|
      t.timestamps
    end
  end
end
