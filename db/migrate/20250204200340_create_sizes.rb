class CreateSizes < ActiveRecord::Migration[8.0]
  def change
    create_table :sizes do |t|
      t.string :size

      t.timestamps
    end
  end
end
