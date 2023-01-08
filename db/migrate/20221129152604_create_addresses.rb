class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :client, null: false, foreign_key: true
      t.string :address_line_1, null: false
      t.string :address_line_2
      t.string :postal_code, null: false
      t.string :city, null: false
      t.string :country, null: false

      t.timestamps
    end
  end
end
