class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :client, null: false, foreign_key: true
      t.string :address_line_1
      t.string :address_line_2
      t.string :postal_code
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
