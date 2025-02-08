class CreateReturnRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :return_requests do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: 'pending'
      t.text :reason
      t.text :admin_notes
      t.datetime :processed_at

      t.timestamps
    end

    add_index :return_requests, :status
  end
end
