class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.integer :age, null: false

      t.timestamps
    end
  end
end
