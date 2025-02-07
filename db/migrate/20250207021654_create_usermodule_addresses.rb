class CreateUsermoduleAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :building_name
      t.string :street_address
      t.string :phone
      t.references :user, null: false, foreign_key: true
      t.string :country_name
      t.string :state_name
      t.string :city_name

      t.timestamps
    end
  end
end
